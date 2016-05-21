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


main =
    Html.App.beginnerProgram
        { model = def3
        , view =
            \model ->
                Html.div []
                    [ Controls.view model
                    , Html.pre [] [ Html.text (toString <| Controls.currentValue model) ]
                    ]
        , update = always
        }
