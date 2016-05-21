module Main exposing (..)

import Html
import Html.App
import Controls


type Animal
    = Monkey
    | Giraffe
    | CustomAnimal String


def1 =
    Controls.string "default value"


def2 =
    Controls.choice
        [ ( "YES", Controls.value True )
        , ( "NO", Controls.value False )
        ]


def3 =
    Controls.choice
        [ ( "Animal"
          , Controls.map Just
                <| Controls.choice
                    [ ( "Monkey", Controls.value Monkey )
                    , ( "Giraffe", Controls.value Giraffe )
                    ]
          )
        , ( "Nothing", Controls.value Nothing )
        , ( "Custom"
          , Controls.map (Just << CustomAnimal)
                <| Controls.string ""
          )
        ]


view model =
    let
        h title =
            Html.h2 [] [ Html.text title ]

        showData data =
            Html.pre [] [ Html.text (toString data) ]
    in
        Html.div []
            [ h "Interactive control"
            , Controls.view model
            , showData (Controls.currentValue model)
            , h "All possible values"
            , List.map showData (Controls.allValues model)
                |> Html.div []
            ]


main =
    Html.App.beginnerProgram
        { model = def3
        , view = view
        , update = always
        }
