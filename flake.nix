{
  description = "Zig Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (
      system: let
        lib = nixpkgs.lib;
        pkgs = import nixpkgs {
          system = "${system}";
          config = {
            allowUnfree = true;
            nvidia.acceptLicense = true;
          };
        };
      in rec {
        devShells = {
          default = pkgs.mkShell rec {
            buildInputs = with pkgs; [
              #################
              ### Libraries ###

              #################
              ### Compilers ###

              #################
            ];

            packages = with pkgs; [
              ### Langs ###
              zig
              zls
              #############

              #############
              ### Tools ###
              #############
            ];

            LD_LIBRARY_PATH = "${lib.makeLibraryPath buildInputs}";
            VK_LAYER_PATH = "${pkgs.vulkan-validation-layers}/share/vulkan/explicit_layer.d";
            VULKAN_SDK = "${pkgs.vulkan-validation-layers}/share/vulkan/explicit_layer.d";
            XDG_DATA_DIRS = builtins.getEnv "XDG_DATA_DIRS";
            XDG_RUNTIME_DIR = "/run/user/1000";
            STB_INCLUDE_PATH = "./headers/stb";
          };
        };
      }
    );
}
