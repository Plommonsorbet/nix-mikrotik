{ mikrotik-config ? ./examples/configuration.nix }:
with import <nixpkgs> { };
with lib;
with builtins;

let
  rtr = (import mikrotik-config);

  formatValue = key: value:
    if key == "comment" then
      ''${key}="${value}"''
    else if key == "no_label" then
      formatValue null value
      #''${key}="${value}"''
    else if isAttrs value && key != null then
      concatStringsSep " " (["${key}"] ++ (mapAttrsToList (k: v: formatValue k v) value))

    else if isAttrs value then
      concatStringsSep " " (mapAttrsToList (k: v: formatValue k v) value)

    else
      "${key}=${value}";

  formatSection = name: opts:
    [ "${name}" ] ++ (if isAttrs opts then
      (mapAttrsToList (k: v: "set ${formatValue k v}") opts)
    else
      (map (x: "add ${formatValue null x}") opts));

in rec {
  mikrotik-router = stdenv.mkDerivation rec {
    version = "0.0.1";
    name = "mikrotik-router-${version}";

    src = builtins.toFile "router-config.asc" (concatStringsSep "\n"
      (flatten (mapAttrsToList (key: values: formatSection key values) rtr)));

    builder = builtins.toFile "builder.sh" ''
      source $stdenv/setup
      mkdir $out
      install $src $out/router-config.asc
    '';
  };
}
