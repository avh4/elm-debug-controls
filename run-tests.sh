#!/bin/bash

set -ex


## clean

if [ "$1" == "--clean" ]; then
  rm -Rf elm-stuff/build-artifacts
  rm -Rf tests/elm-stuff/build-artifacts
  rm -Rf examples/elm-stuff/build-artifacts
fi


## src

elm-make --yes


## tests

elm-test


## examples

mkdir -p docs
cp examples/*.svg docs/
pushd examples
elm-make --yes Main.elm --output ../docs/index.html
popd
