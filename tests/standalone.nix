{ pkgs, ... }:

pkgs.nixosTest {
  name = "simple-fdbserver-test";
  nodes.machine = { ... }:
    {
      environment.systemPackages = [ pkgs.fdbserver74 pkgs.fdbcli74 ];

      # Create fdb user and group
      users.users.fdb = {
        isSystemUser = true;
        group = "fdb";
      };
      users.groups.fdb = {};

      # Create the cluster file
      environment.etc."foundationdb/fdb.cluster".text = "docker:docker@127.0.0.1:4500";

      # Create the data directory
      systemd.tmpfiles.rules = [
        "d /var/lib/foundationdb 0755 fdb fdb -"
        "d /var/lib/foundationdb/data 0755 fdb fdb -"
      ];
    };

  testScript = ''
    start_all()
    machine.wait_for_unit("multi-user.target")

    # Start fdbserver in the background
    machine.succeed(
        "fdbserver "
        "--cluster-file /etc/foundationdb/fdb.cluster "
        "--datadir /var/lib/foundationdb/data "
        "--public-address 127.0.0.1:4500 >& /tmp/fdb.log &"
    )

    # Wait for the server to start listening on its port
    machine.wait_for_open_port(4500)

    # Check the status using fdbcli
    machine.succeed("fdbcli --exec 'configure new single memory' --timeout 10")
    machine.succeed("fdbcli --exec 'status' --timeout 10")
    machine.succeed("fdbcli --exec 'writemode on; set hello world' --timeout 2")
    machine.succeed("fdbcli --exec 'get hello' --timeout 2 | grep 'world'")
  '';
}
