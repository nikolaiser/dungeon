{
  dungeon.shell = {
    homeManager =
      { lib, pkgs, ... }:
      {
        programs.fish = {
          enable = true;

          shellInit = # fish
            ''
              fish_default_key_bindings
              set fish_greeting  # disable greeting
            '';

          shellAliases = {
            ls = "${lib.getExe pkgs.eza}";
            la = "${lib.getExe pkgs.eza} -la";
            tree = "${lib.getExe pkgs.eza} -T";
            htop = "${lib.getExe pkgs.bottom}";
            cat = "${lib.getExe pkgs.bat}";
            nano = "${lib.getExe pkgs.micro}";
            #ga = "git add";
            gc = "git commit";
            #gco = "git checkout";
            gp = "git push";
            ps = "${lib.getExe pkgs.procs}";
            jn = "${lib.getExe pkgs.jujutsu} new";
            jl = "${lib.getExe pkgs.jujutsu} log";
            je = "${lib.getExe pkgs.jujutsu} edit";
            jbm = "${lib.getExe pkgs.jujutsu} bookmark move --to @";
            jbc = "${lib.getExe pkgs.jujutsu} bookmark create";
            jd = "${lib.getExe pkgs.jujutsu} describe";
            jp = "${lib.getExe pkgs.jujutsu} git push";
            jf = "${lib.getExe pkgs.jujutsu} git fetch";
            ji = "${lib.getExe pkgs.jujutsu} git init --colocate .";
          };

          functions = {
            envsource = ''
              for line in (cat $argv | grep -v '^#' |  grep -v '^\s*$' | sed -e 's/=/ /' -e "s/'//g" -e 's/"//g' )                                                                                                            
                set export (string split ' ' $line)                                                                                                                                                                           
                set -gx $export[1] $export[2]                                                                                                                                                                                 
                echo "Exported key $export[1]"                                                                                                                                                                                
              end'';
          };
        };
      };
  };
}
