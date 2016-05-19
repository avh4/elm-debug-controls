module Main exposing (..)

import Html
import Controls


def1 =
    Controls.string "default value"


def2 =
    Controls.choice ( "YES", True )
        [ ( "NO", False )
        ]


main =
    def2
        |> Controls.init
        |> Controls.view
