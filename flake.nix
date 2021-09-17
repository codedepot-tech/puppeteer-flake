{
  description = "new method";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    puppeteer-src = { url = "github:puppeteer/puppeteer"; flake = false; };
  };

  outputs = { self, nixpkgs, puppeteer-src }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ self.overlay ];
      };
    in rec 
      {
        overlay = final: prev: {
          puppeteer = prev.mkYarnPackage {
            name = "puppeteer";
            src = puppeteer-src;
            packageJSON = ./package.json;
            yarnLock = ./yarn.lock;
          };
        };
        defaultPackage.${system} = pkgs.puppeteer;
        packages.${system} = {
          inherit (pkgs) puppeteer;
        };
      };
}
