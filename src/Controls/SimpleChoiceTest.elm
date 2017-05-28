module Controls.SimpleChoiceTest exposing (all)

import Debug.Control as Control
import Expect
import Html
import Html.Attributes as Html
import Test exposing (..)


yesNoControls =
    Control.choice
        [ ( "YES", Control.value True )
        , ( "NO", Control.value False )
        ]


all : Test
all =
    describe "Control.choice"
        [ test "initial value is the first choice" <|
            \() ->
                yesNoControls
                    |> Control.currentValue
                    |> Expect.equal True

        -- , yesNoControls
        --     |> Control.view
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
