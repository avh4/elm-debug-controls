module Controls.SimpleChoiceTest exposing (all)

import ElmTest exposing (..)
import Controls
import Html
import Html.Attributes as Html


yesNoControls =
    Controls.choice
        [ ( "YES", Controls.value True )
        , ( "NO", Controls.value False )
        ]


all : Test
all =
    suite "Controls.choice"
        [ yesNoControls
            |> Controls.currentValue
            |> assertEqual True
            |> test "initial value is the first choice"
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
