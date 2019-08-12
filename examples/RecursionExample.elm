module RecursionExample exposing (RecursiveType, init, view)

import Debug.Control exposing (Control, choice, lazy, list, map, string, value, values)
import Html exposing (Html)
import Html.Attributes as Html exposing (style)
import String


type RecursiveType
    = RecursiveType { child : Maybe RecursiveType }


init : Control RecursiveType
init =
    choice
        [ ( "No child", value Nothing )
        , ( "child", lazy (\() -> init) |> map Just )
        ]
        |> map (\child -> RecursiveType { child = child })


view : Control RecursiveType -> Html (Control RecursiveType)
view control =
    let
        h title =
            Html.h2 [] [ Html.text title ]
    in
    Html.div []
        [ h "Recursively-defined values"
        , Debug.Control.view identity control
        ]
