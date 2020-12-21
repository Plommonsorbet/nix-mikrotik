{
  "/interface bridge" = [

    {
      auto-mac = "no";
      comment = "defconf";
      name = "bridge";
    }
    { name = "wifi"; }
  ];
  "/interface list" = [ { name = "LAN"; } { name = "WAN"; } ];

  "/ip pool" = [
    {
      name = "wired-pool";
      ranges = "10.10.10.10-10.10.10.254";
    }
    {
      name = "wifi-pool";
      ranges = "10.10.11.10-10.10.11.254";
    }
  ];

  "/ip dhcp-server" = [
    {
      address-pool = "wired-pool";
      disabled = "no";
      interface = "bridge";
      name = "wired-dhcp";
    }
    {
      address-pool = "wifi-pool";
      disabled = "no";
      interface = "wifi";
      name = "wifi-dhcp";
    }
  ];

  "/interface bridge port" = [
    {
      bridge = "bridge";
      interface = "ether2";
    }
    {
      bridge = "bridge";
      interface = "ether3";
    }
    {
      bridge = "bridge";
      interface = "ether4";
    }
    {
      bridge = "wifi";
      interface = "ether5";
    }
    {
      bridge = "bridge";
      interface = "sfp1";
    }
  ];

  "/ip neighbor discovery-settings" = { discover-interface-list = "none"; };

  "/interface list member" = [
    {
      interface = "bridge";
      list = "LAN";
    }
    {
      interface = "ether1";
      list = "WAN";
    }

  ];

  "/ip address" = [
    {
      address = "10.10.10.1/24";
      interface = "ether2";
      network = "10.10.10.0";
    }
    {
      address = "10.10.11.1/24";
      interface = "wifi";
      network = "10.10.11.0";
    }
  ];
  "/ip cloud" = {
    update-time = "no";

  };

  "/ip dhcp-client" = [{
    disabled = "no";
    interface = "ether1";
  }];
  "/ip dhcp-server network" = [
    {
      address = "10.10.10.0/24";
      gateway = "10.10.10.1";
      netmask = "24";
    }
    {
      address = "10.10.11.0/24";
      gateway = "10.10.11.1";
      netmask = "24";
    }
  ];

  "/ip dns" = {

    no_label = {
      allow-remote-requests = "yes";
      servers = "1.1.1.1,1.0.0.1";
    };
  };
  "/ip dns static" = [{
    address = "10.10.10.1";
    name = "router.lan";
  }];
  "/ip firewall address-list" = [
    {
      address = "10.10.10.10-10.10.10.10.254";
      list = "allowed_to_router";
    }
    {
      action = "accept";
      chain = "input";
      src-address-list = "allowed_to_router";
    }
    {
      action = "accept";
      chain = "input";
      protocol = "icmp";
    }
  ];

  "/ip service" = {
    telnet = { disabled = "yes"; };
    www = { disabled = "yes"; };
    ftp = { disabled = "yes"; };
    winbox = { disabled = "yes"; };
    api-ssl = { disabled = "yes"; };
    api = { disabled = "yes"; };

  };

  "/ip ssh" = { strong-crypto = "yes"; };
  "/system clock" = { time-zone-name = "Europe/Stockholm"; };
  "/system identity" = { name = "nidas"; };
  "/tool bandwidth-server" = { enabled = "no"; };
  "/tool mac-server" = { allowed-interface-list = "none"; };
  "/tool mac-server mac-winbox" = { allowed-interface-list = "none"; };
  "/tool mac-server ping" = { enabled = "no"; };

}
