{
  inputs = {
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      fenix,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
        rust-toolchain = fenix.packages.${system}.fromToolchainFile {
          file = ./rust-toolchain.toml;
          sha256 = "sha256-X/4ZBHO3iW0fOenQ3foEvscgAPJYl2abspaBThDOukI=";
        };
      in
      {
        devShells.default =
          with pkgs;
          mkShell {
            nativeBuildInputs = [
              rust-toolchain
              llvmPackages.lldb # https://lldb.llvm.org/resources/lldbdap.html
            ];
            buildInputs = [

            ];

            # https://github.com/NixOS/nixpkgs/issues/252838#issuecomment-2598171564
            shellHook = ''
              export LLDB_DEBUGSERVER_PATH=/Applications/Xcode.app/Contents/SharedFrameworks/LLDB.framework/Resources/debugserver
            '';
          };

        formatter = pkgs.nixfmt-rfc-style;
      }
    );
}
