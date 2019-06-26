{ pkgs ? import <nixpkgs> {} }:

with pkgs;

stdenv.mkDerivation {
  name = "redstone-gen";
  buildInputs = [ python37 clingo ];
}
