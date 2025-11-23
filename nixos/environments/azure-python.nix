{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  packages = with pkgs; [
    azure-functions-core-tools
    lazydocker
    azure-cli
    bruno
    tenv
    ty
    uv
    jq
  ];
}
