#!/bin/bash

set -e
set -v

if [ "$1" == "--clean" ]; then
  rm -Rf elm-stuff/build-artifacts
  elm-make src/Main.elm --output build/main.js
  rm -Rf elm-stuff/build-artifacts
fi

if ! npm list | grep " jsdom@"; then
  npm install jsdom@3
fi

mkdir -p build
elm-make src/TestRunner.elm --output build/test.js
./elm-io.sh build/test.js build/test.io.js
node build/test.io.js
