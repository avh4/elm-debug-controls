module Controls.StringTest exposing (all)

import Controls
import Expect
import Html
import Html.Attributes as Html
import Test exposing (..)


stringControls =
    Controls.string "default"


all : Test
all =
    describe "Controls.string"
        [ test "initial value" <|
            \() ->
                stringControls
                    |> Controls.currentValue
                    |> Expect.equal "default"

        -- , stringControls
        --     |> Controls.view
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
