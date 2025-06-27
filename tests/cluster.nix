{ pkgs, ... }:

pkgs.nixosTest {
  name = "fdb-cluster-test";
  nodes = {
    node1 = { ... }:
      {
        networking.firewall.enable = false;
        networking.interfaces.eth1.ipv4.addresses = [ { address = "192.168.1.1"; prefixLength = 24; } ];
        environment.systemPackages = [ pkgs.fdbserver74 pkgs.fdbcli74 pkgs.toybox ];
        users.users.fdb = {
          isSystemUser = true;
          group = "fdb";
        };
        users.groups.fdb = {};
        environment.etc."foundationdb/fdb.cluster".text = "docker:docker@192.168.1.1:4500";
        systemd.tmpfiles.rules = [
          "d /var/lib/foundationdb 0755 fdb fdb -"
          "d /var/lib/foundationdb/data 0755 fdb fdb -"
        ];
      };
    node2 = { ... }:
      {
        networking.firewall.enable = false;
        networking.interfaces.eth1.ipv4.addresses = [ { address = "192.168.1.2"; prefixLength = 24; } ];
        environment.systemPackages = [ pkgs.fdbserver74 pkgs.fdbcli74 pkgs.toybox ];
        users.users.fdb = {
          isSystemUser = true;
          group = "fdb";
        };
        users.groups.fdb = {};
        environment.etc."foundationdb/fdb.cluster".text = "docker:docker@192.168.1.1:4500";
        systemd.tmpfiles.rules = [
          "d /var/lib/foundationdb 0755 fdb fdb -"
          "d /var/lib/foundationdb/data 0755 fdb fdb -"
        ];
      };
  };

  testScript = ''
    start_all()
    node1.wait_for_unit("multi-user.target")
    node2.wait_for_unit("multi-user.target")

    node1.succeed(
        "fdbserver "
        "--cluster-file /etc/foundationdb/fdb.cluster "
        "--datadir /var/lib/foundationdb/data "
        "--public-address 192.168.1.1:4500 >& /tmp/fdb1.log &"
    )
    node2.succeed(
        "fdbserver "
        "--cluster-file /etc/foundationdb/fdb.cluster "
        "--datadir /var/lib/foundationdb/data "
        "--public-address 192.168.1.2:4500 >& /tmp/fdb2.log &"
    )

    node1.wait_for_open_port(4500, "192.168.1.1")
    node2.wait_for_open_port(4500, "192.168.1.2")

    # assert that network is opened
    node1.succeed("ping 192.168.1.2 -c 1")
    node2.succeed("ping 192.168.1.1 -c 1")
    node1.succeed("nc -z 192.168.1.2 4500")
    node2.succeed("nc -z 192.168.1.1 4500")

    node1.succeed("fdbcli --exec 'configure new single memory' --timeout 10")
    output = node1.succeed("fdbcli --exec 'status' --timeout 2")
    node1.log(output)

    node1.succeed("fdbcli --exec 'status' --timeout 2 | grep 'FoundationDB processes - 2'")
  '';
}
