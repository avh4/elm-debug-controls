module Controls.ComplexChoiceTest exposing (all)

import Debug.Control as Control
import Expect
import Html
import Html.Attributes as Html
import Test exposing (..)


type Animal
    = Monkey
    | Giraffe


maybeControls =
    Control.choice
        [ ( "Animal"
          , Control.map Just <|
                Control.choice
                    [ ( "Monkey", Control.value Monkey )
                    , ( "Giraffe", Control.value Giraffe )
                    ]
          )
        , ( "---", Control.value Nothing )
        ]


all : Test
all =
    describe "Control.choice (complex)"
        [ test "initial value is the first choice" <|
            \() ->
                maybeControls
                    |> Control.currentValue
                    |> Expect.equal (Just Monkey)

        -- , maybeControls
        --     |> Control.view
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
                    |> Control.allValues
                    |> Expect.equal
                        [ Just Monkey
                        , Just Giraffe
                        , Nothing
                        ]
        ]
