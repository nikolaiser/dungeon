rebuild OPERATION USER HOST:
  NIX_SSHOPTS="-t -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null" nixos-rebuild {{OPERATION}} < /dev/null --use-remote-sudo --target-host {{USER}}@{{HOST}}.local --cores 0 --show-trace --impure --flake .#{{HOST}} |& nom

switch USER HOST:
  just rebuild switch {{USER}} {{HOST}}

boot USER HOST:
  just rebuild boot {{USER}} {{HOST}}
