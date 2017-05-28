module Controls.SimpleChoiceTest exposing (all)

import Controls
import Expect
import Html
import Html.Attributes as Html
import Test exposing (..)


yesNoControls =
    Controls.choice
        [ ( "YES", Controls.value True )
        , ( "NO", Controls.value False )
        ]


all : Test
all =
    describe "Controls.choice"
        [ test "initial value is the first choice" <|
            \() ->
                yesNoControls
                    |> Controls.currentValue
                    |> Expect.equal True

        -- , yesNoControls
        --     |> Controls.view
        --     |> assertEqual
        --         (Html.div []
        --             [ Html.div []
        --                 [ Html.select []
        --                     [ Html.option [ Html.selected True ] [ Html.text "YES" ]
        --                     , Html.option [ Html.selected False ] [ Html.text "NO" ]
        --                     ]
        --                 , Html.div [] [ Html.text "" ]
        --                 ]
        --             ]
        --         )
        --     |> test "Renders all options"
        ]
