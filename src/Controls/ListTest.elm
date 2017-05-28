module Controls.ListTest exposing (all)

import Debug.Control as Control
import Expect
import Html
import Html.Attributes as Html
import Test exposing (..)


listControl =
    Control.list <| Control.values [ "A", "B" ]


all : Test
all =
    describe "Control.list"
        [ test "initial value" <|
            \() ->
                listControl
                    |> Control.currentValue
                    |> Expect.equal [ "A" ]
        ]
