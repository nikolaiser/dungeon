{
  config,
  pkgs,
  ...
}:

let
  forwardToTelegram = pkgs.writeShellScriptBin "forward-to-telegram" ''
    send_to_telegram() {
        local message=$1
        ${pkgs.curl}/bin/curl -s -X POST "https://api.telegram.org/bot''${TELEGRAM_BOT_TOKEN}/sendMessage" \
            -d chat_id="''${TELEGRAM_CHAT_ID}" \
            -d text="''${message}" > /dev/null
    }

    ${pkgs.dbus}/bin/dbus-monitor --system "interface='net.nuetzlich.SystemNotifications'" | \
    while read -r line; do
        if echo "$line" | grep -q 'string'; then
            message=$(echo "$line" | sed -E 's/^\s*string//')
            send_to_telegram "$message"
        fi
    done
  '';
in
{

  services.smartd = {
    enable = true;
    autodetect = true;
    notifications.systembus-notify.enable = true;
  };

  systemd.services.forwardToTelegram = {
    serviceConfig = {
      ExecStart = "${forwardToTelegram}/bin/forward-to-telegram";
      Restart = "always";
      EnvironmentFile = config.age.secrets."telegram-notifications.env".path;
    };
    wantedBy = [ "multi-user.target" ];
  };

}
