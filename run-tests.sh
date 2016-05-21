#!/bin/bash

set -ex

if [ "$1" == "--clean" ]; then
  rm -Rf elm-stuff/build-artifacts
  rm -Rf tests/elm-stuff/build-artifacts
  rm -Rf examples/elm-stuff/build-artifacts
fi

elm-make --yes

cd tests
elm-make TestRunner.elm --output tests.js
node tests.js

cd ../examples
elm-make --yes Main.elm
