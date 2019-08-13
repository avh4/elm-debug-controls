module Controls.ListTest exposing (all)

import Debug.Control as Control exposing (Control)
import Expect
import Html
import Html.Attributes as Html
import Test exposing (..)


listControl : Control (List String)
listControl =
    Control.list (List.map Control.value [ "A", "B" ])


all : Test
all =
    describe "Control.list"
        [ test "initial value" <|
            \() ->
                listControl
                    |> Control.currentValue
                    |> Expect.equal [ "A" ]
        ]
