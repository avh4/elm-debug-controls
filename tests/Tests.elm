module Tests exposing (..)

import ElmTest exposing (..)
import Controls.SimpleChoiceTest


all : Test
all =
    suite "elm-debug-controls"
        [ Controls.SimpleChoiceTest.all
        ]
