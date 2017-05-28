module Controls.ComplexChoiceTest exposing (all)

import Controls
import Expect
import Html
import Html.Attributes as Html
import Test exposing (..)


type Animal
    = Monkey
    | Giraffe


maybeControls =
    Controls.choice
        [ ( "Animal"
          , Controls.map Just <|
                Controls.choice
                    [ ( "Monkey", Controls.value Monkey )
                    , ( "Giraffe", Controls.value Giraffe )
                    ]
          )
        , ( "---", Controls.value Nothing )
        ]


all : Test
all =
    describe "Controls.choice (complex)"
        [ test "initial value is the first choice" <|
            \() ->
                maybeControls
                    |> Controls.currentValue
                    |> Expect.equal (Just Monkey)

        -- , maybeControls
        --     |> Controls.view
        --     |> assertEqual
        --         (Html.div []
        --             [ Html.div []
        --                 [ Html.select []
        --                     [ Html.option [ Html.selected True ] [ Html.text "Animal" ]
        --                     , Html.option [ Html.selected False ] [ Html.text "---" ]
        --                     ]
        --                 , Html.div []
        --                     [ Html.div []
        --                         [ Html.select []
        --                             [ Html.option [ Html.selected True ] [ Html.text "Monkey" ]
        --                             , Html.option [ Html.selected False ] [ Html.text "Giraffe" ]
        --                             ]
        --                         , Html.div [] [ Html.text "" ]
        --                         ]
        --                     ]
        --                 ]
        --             ]
        --         )
        --     |> test "Renders all options"
        , test "allValues" <|
            \() ->
                maybeControls
                    |> Controls.allValues
                    |> Expect.equal
                        [ Just Monkey
                        , Just Giraffe
                        , Nothing
                        ]
        ]
