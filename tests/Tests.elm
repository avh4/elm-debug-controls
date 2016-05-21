module Tests exposing (..)

import ElmTest exposing (..)
import Controls.ComplexChoiceTest
import Controls.ListTest
import Controls.SimpleChoiceTest
import Controls.StringTest


all : Test
all =
    suite "elm-debug-controls"
        [ Controls.ComplexChoiceTest.all
        , Controls.ListTest.all
        , Controls.SimpleChoiceTest.all
        , Controls.StringTest.all
        ]
