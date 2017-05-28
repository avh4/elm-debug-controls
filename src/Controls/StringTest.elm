module Controls.StringTest exposing (all)

import Debug.Control as Control
import Expect
import Html
import Html.Attributes as Html
import Test exposing (..)


stringControls =
    Control.string "default"


all : Test
all =
    describe "Control.string"
        [ test "initial value" <|
            \() ->
                stringControls
                    |> Control.currentValue
                    |> Expect.equal "default"

        -- , stringControls
        --     |> Control.view
        --     |> assertEqual
        --         (Html.div []
        --             [ Html.input
        --                 [ Html.value "default"
        --                 ]
        --                 []
        --             ]
        --         )
        --     |> test "Renders all options"
        ]
