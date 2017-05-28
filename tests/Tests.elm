module Tests exposing (..)

import Controls.ComplexChoiceTest
import Controls.ListTest
import Controls.SimpleChoiceTest
import Controls.StringTest
import Test exposing (..)


all : Test
all =
    describe "elm-debug-controls"
        [ Controls.ComplexChoiceTest.all
        , Controls.ListTest.all
        , Controls.SimpleChoiceTest.all
        , Controls.StringTest.all
        ]
