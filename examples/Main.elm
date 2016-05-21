module Main exposing (..)

import Html
import Html.App
import Controls exposing (choice, string, value)


type Animal
    = Monkey
    | Giraffe
    | CustomAnimal String


def1 =
    string "default value"


def2 =
    choice
        [ ( "YES", value True )
        , ( "NO", value False )
        ]


def3 =
    choice
        [ ( "Animal"
          , Controls.map Just
                <| choice
                    [ ( "Monkey", value Monkey )
                    , ( "Giraffe", value Giraffe )
                    ]
          )
        , ( "Nothing", value Nothing )
        , ( "Custom"
          , Controls.map (Just << CustomAnimal)
                <| string "Zebra"
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
