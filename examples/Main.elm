module Main exposing (..)

import Html
import Controls


type Animal
    = Monkey
    | Giraffe


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
        , ( "---", Controls.value Nothing )
        ]


main =
    def3
        |> Controls.view
