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
            |> Controls.currentValue
            |> assertEqual "default"
            |> test "initial value"
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
