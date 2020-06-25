{ nixpkgs ? import <nixpkgs> { }, compiler ? "default" }:

let

  inherit (nixpkgs) pkgs;

  pkg = pkgs.haskellPackages.callCabal2nix "nix2json" (builtins.path {
    path = "/home/aloysius/Projects/haskell/mine/nix2json";
    name = "nix2json";
  });

  drv = pkgs.haskellPackages.callPackage pkg { };

in if pkgs.lib.inNixShell then drv.env else drv
