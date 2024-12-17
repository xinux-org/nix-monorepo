let
  rust_overlay = import (builtins.fetchTarball "https://github.com/oxalica/rust-overlay/archive/master.tar.gz");
  nixpkgs = import <nixpkgs> { overlays = [ rust_overlay ]; };
  rust_channel = nixpkgs.rust-bin.fromRustupToolchainFile ./rust-toolchain.toml;
in
with nixpkgs;

pkgs.mkShell {
  nativeBuildInputs = [pkg-config] ++ (with pkgs; [
    openssl
    libgit2
    sqlite
  ]);

  buildInputs = (with pkgs; [
    flutter
    android-tools
    pandoc
  ]);

  LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [
    pkgs.openssl
    pkgs.libgit2
    pkgs.sqlite
  ];
  
  RUST_SRC_PATH = "${rust_channel}/lib/rustlib/src/rust/library";
  LINK_MANPAGES_PANDOC_FILTER = import ./nixos-search/flake-info/src/data/link-manpages.nix { inherit pkgs; };

  shellHook = ''
    export PATH="$PATH:${rust_channel}/bin"
  '';
}
