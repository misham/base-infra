#cloud-config

coreos:
  etcd2:
    # generate a new token for each unique cluster from https://discovery.etcd.io/new:
    discovery: ${etcd_discovery_url}
    # multi-region deployments, multi-cloud deployments, and Droplets without
    # private networking need to use $public_ipv4:
    advertise-client-urls: http://$private_ipv4:2379,http://$private_ipv4:4001
    initial-advertise-peer-urls: http://$private_ipv4:2380
    # listen on the official ports 2379, 2380 and one legacy port 4001:
    listen-client-urls: http://0.0.0.0:2379,http://0.0.0.0:4001
    listen-peer-urls: http://$private_ipv4:2380
  fleet:
    public-ip: $private_ipv4   # used for fleetctl ssh command
  units:
    - name: etcd2.service
      command: start
    - name: fleet.service
      command: start
