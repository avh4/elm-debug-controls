module RecursionExample exposing (RecursiveType, init, view)

import Debug.Control exposing (Control, choice, list, map, string, value, values)
import Html exposing (Html)
import Html.Attributes as Html exposing (style)
import String


type RecursiveType
    = RecursiveType { choice : Bool, child : Maybe RecursiveType }


init : Control RecursiveType
init =
    --Debug.Control.andThen
    Debug.Control.map
        (\b ->
            --        if b then
            --                (\child -> RecursiveType { choice = b, child = Just child })
            --                init
            --        else
            RecursiveType { choice = b, child = Nothing }
        )
        (Debug.Control.bool False)


view : Control RecursiveType -> Html (Control RecursiveType)
view control =
    let
        h title =
            Html.h2 [] [ Html.text title ]
    in
    Html.div []
        [ h "Example data structure"
        , Debug.Control.view identity control
        ]
