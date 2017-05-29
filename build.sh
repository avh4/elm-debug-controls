#!/bin/bash

set -ex

mkdir -p docs
cp examples/*.svg docs/

pushd examples
elm-make --yes Main.elm --output ../docs/index.html
popd
