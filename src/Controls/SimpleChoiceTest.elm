module Controls.SimpleChoiceTest exposing (all)

import ElmTest exposing (..)
import Controls
import Html


yesNoControls =
    Controls.choice ( "YES", True )
        [ ( "NO", False ) ]


all : Test
all =
    suite "Controls.choice"
        [ yesNoControls
            |> Controls.init
            |> Controls.currentValue
            |> assertEqual True
            |> test "initial value is the first choice"
        , yesNoControls
            |> Controls.init
            |> Controls.view
            |> assertEqual
                (Html.div []
                    [ Html.select []
                        [ Html.option [] [ Html.text "YES" ]
                        , Html.option [] [ Html.text "NO" ]
                        ]
                    ]
                )
            |> test "Renders all options"
        ]
