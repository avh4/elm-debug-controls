module Controls.StringTest exposing (all)

import ElmTest exposing (..)
import Controls
import Html
import Html.Attributes as Html


stringControls =
    Controls.string "default"


all : Test
all =
    suite "Controls.string"
        [ stringControls
            |> Controls.init
            |> Controls.currentValue
            |> assertEqual "default"
            |> test "initial value"
        , stringControls
            |> Controls.init
            |> Controls.view
            |> assertEqual
                (Html.div []
                    [ Html.input
                        [ Html.value "default"
                        ]
                        []
                    ]
                )
            |> test "Renders all options"
        ]
