module Main exposing (..)

import AnimalExample
import BeautifulExample
import Color
import Debug.Control exposing (Control, choice, list, map, string, value, values)
import Html
import Html.Attributes as Html exposing (style)
import String


stringControl : Control String
stringControl =
    string "default value"


choiceControl : Control Bool
choiceControl =
    choice
        [ ( "YES", value True )
        , ( "NO", value False )
        ]


main =
    BeautifulExample.beginnerProgram
        { title = "elm-debug-controls"
        , details = Just """This package helps you easily create interactive and exhaustive views of complex data structures."""
        , color = Just Color.brown
        , maxWidth = 600
        , githubUrl = Just "https://github.com/avh4/elm-debug-controls"
        , documentationUrl = Just "http://packages.elm-lang.org/packages/avh4/elm-debug-controls/latest"
        }
        { model = AnimalExample.debugControl
        , view = AnimalExample.view
        , update = always
        }
