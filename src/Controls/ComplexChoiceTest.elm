module Controls.ComplexChoiceTest exposing (all)

import ElmTest exposing (..)
import Controls
import Html
import Html.Attributes as Html


type Animal
    = Monkey
    | Giraffe


maybeControls =
    Controls.choice
        ( "Animal"
        , Controls.map Just
            <| Controls.choice ( "Monkey", Controls.value Monkey )
                [ ( "Giraffe", Controls.value Giraffe )
                ]
        )
        [ ( "---", Controls.value Nothing )
        ]


all : Test
all =
    suite "Controls.choice"
        [ maybeControls
            |> Controls.currentValue
            |> assertEqual (Just Monkey)
            |> test "initial value is the first choice"
        , maybeControls
            |> Controls.view
            |> assertEqual
                (Html.div []
                    [ Html.div []
                        [ Html.select []
                            [ Html.option [ Html.selected True ] [ Html.text "Animal" ]
                            , Html.option [ Html.selected False ] [ Html.text "---" ]
                            ]
                        , Html.div []
                            [ Html.div []
                                [ Html.select []
                                    [ Html.option [ Html.selected True ] [ Html.text "Monkey" ]
                                    , Html.option [ Html.selected False ] [ Html.text "Giraffe" ]
                                    ]
                                , Html.div [] [ Html.text "" ]
                                ]
                            ]
                        ]
                    ]
                )
            |> test "Renders all options"
        ]
