#!/bin/sh
pushd ~/.dotfiles
home-manager switch -f ./users/nini/home.nix
popd
