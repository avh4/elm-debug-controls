module Tests exposing (..)

import ElmTest exposing (..)
import Controls.SimpleChoiceTest
import Controls.StringTest


all : Test
all =
    suite "elm-debug-controls"
        [ Controls.SimpleChoiceTest.all
        , Controls.StringTest.all
        ]
