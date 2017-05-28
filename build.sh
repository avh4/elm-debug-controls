#!/bin/bash

set -ex

pushd examples
elm-make --yes Main.elm --output ../docs/index.html
elm-make --yes Dropbox.elm --output ../docs/dropbox.html
popd
