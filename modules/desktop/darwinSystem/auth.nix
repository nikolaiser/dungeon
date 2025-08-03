_:

{
  security.pam.services.sudo_local = {
    enable = true;
    touchIdAuth = true;
    reattach = true;
    #text = "auth sufficient pam_tid.so.2";
  };
}
