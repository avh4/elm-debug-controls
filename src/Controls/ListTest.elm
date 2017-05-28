module Controls.ListTest exposing (all)

import Controls
import Expect
import Html
import Html.Attributes as Html
import Test exposing (..)


listControl =
    Controls.list <| Controls.values [ "A", "B" ]


all : Test
all =
    describe "Controls.list"
        [ test "initial value" <|
            \() ->
                listControl
                    |> Controls.currentValue
                    |> Expect.equal [ "A" ]
        ]
