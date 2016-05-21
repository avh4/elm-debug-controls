module Controls.ListTest exposing (all)

import ElmTest exposing (..)
import Controls
import Html
import Html.Attributes as Html


listControl =
    Controls.list <| Controls.values [ "A", "B" ]


all : Test
all =
    suite "Controls.string"
        [ listControl
            |> Controls.currentValue
            |> assertEqual [ "A" ]
            |> test "initial value"
        ]
