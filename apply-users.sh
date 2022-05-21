#!/bin/sh
pushd ~/.dotfiles
nix build .#homeManagerConfigurations.nini.activationPackage
./result/activate
popd
