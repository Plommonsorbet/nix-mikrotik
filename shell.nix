let
  moz_overlay = import (builtins.fetchTarball
    "https://github.com/mozilla/nixpkgs-mozilla/archive/master.tar.gz");
  nixpkgs = import <nixpkgs> { overlays = [ moz_overlay ]; };

  rust_nightly = (nixpkgs.latest.rustChannels.nightly.rust.override {
    extensions = [
      #"rust-src"
      "rust-analysis"
      "clippy-preview"
      "rustfmt-preview"
      "rls-preview"
    ]

    ;
  });
in with nixpkgs;
stdenv.mkDerivation {
  name = "nix-mikrotik";
  buildInputs = [ rust_nightly rustfmt openssl pkg-config];
}
