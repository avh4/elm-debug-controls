module RecursionExample exposing (RecursiveType, init, view)

import Debug.Control exposing (Control, choice, list, map, string, value, values)
import Html exposing (Html)
import Html.Attributes as Html exposing (style)
import String


type RecursiveType
    = RecursiveType { choice : Bool, child : Maybe RecursiveType }


init : Control RecursiveType
init =
    Debug.Control.andThen
        (\b ->
            if b then
                Debug.Control.map
                    (\child -> RecursiveType { choice = b, child = Just child })
                    init

            else
                Debug.Control.value
                    (RecursiveType { choice = b, child = Nothing })
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
