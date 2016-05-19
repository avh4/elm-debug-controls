module Tests exposing (..)

import ElmTest exposing (..)
import FooTest


all : Test
all =
    suite "elm-debug-controls"
        [ FooTest.all
        ]
