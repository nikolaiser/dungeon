rebuild OPERATION HOST:
  NIX_SSHOPTS="-t -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null" nixos-rebuild {{OPERATION}} < /dev/null --use-remote-sudo --target-host ops@{{HOST}}.local --cores 0 --show-trace --flake .#{{HOST}} |& nom

switch HOST:
  just rebuild switch {{HOST}}

boot HOST:
  just rebuild boot {{HOST}}
