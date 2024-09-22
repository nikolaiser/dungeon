rebuild OPERATION HOST:
  NIX_SSHOPTS="-t -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null" nixos-rebuild {{OPERATION}} < /dev/null --use-remote-sudo --target-host ops@{{HOST}}.local --show-trace --flake .#{{HOST}}

switch HOST:
  just rebuild switch {{HOST}}

switch-servers:
  just switch sina
  just switch maria
  just switch rose
  just switch nas

boot HOST:
  just rebuild boot {{HOST}}

boot-servers:
  just boot sina
  just boot maria
  just boot rose
  just boot nas

