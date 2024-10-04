{ pkgs, lib, ... }:

{
  programs.wlogout = {
    enable = true;

    layout = [
      {
        label = "lock";
        action = "${lib.exe pkgs.swaylock}";
        text = "Lock";
        keybind = "l";
      }
      {
        label = "hibernate";
        action = "systemctl hibernate";
        text = "Hibernate";
        keybind = "h";
      }
      {
        label = "logout";
        action = "loginctl terminate-user $USER";
        text = "Logout";
        keybind = "e";
      }
      {
        label = "shutdown";
        action = "systemctl poweroff";
        text = "Shutdown";
        keybind = "s";
      }
      {
        label = "suspend";
        action = "systemctl suspend";
        text = "Suspend";
        keybind = "u";
      }
      {
        label = "reboot";
        action = "systemctl reboot";
        text = "Reboot";
        keybind = "r";
      }
    ];

    style = # css
      ''
        /** ********** Fonts ********** **/
        * {
            font-family: "Iosevka Nerd Font", sans-serif;
            font-size: 14px;
            font-weight: bold;
        }

        /** ********** Main Window ********** **/
        window {
          background-color: #1E1E2E;
        }

        /** ********** Buttons ********** **/
        button {
          background-color: #242434;
            color: #FFFFFF;
          border: 2px solid #282838;
          border-radius: 20px;
          background-repeat: no-repeat;
          background-position: center;
          background-size: 35%;
        }

        button:focus, button:active, button:hover {
          background-color: #89B4FA;
          outline-style: none;
        }

        /** ********** Icons ********** **/
        #lock {
            background-image: image(url("${./icons/lock.png}"));
        }

        #logout {
            background-image: image(url("${./icons/logout.png}"));
        }

        #suspend {
            background-image: image(url("${./icons/suspend.png}"));
        }

        #hibernate {
            background-image: image(url("${./icons/hibernate.png}"));
        }

        #shutdown {
            background-image: image(url("${./icons/shutdown.png}"));
        }

        #reboot {
            background-image: image(url("${./icons/reboot.png}"));
        }'';
  };
}
