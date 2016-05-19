module Controls exposing (choice, init, currentValue, view)

import Html exposing (Html)


type Definition a
    = Choice ( String, a ) (List ( String, a ))


type Model a
    = Model
        { currentValue : a
        , definition : Definition a
        }


choice : ( String, a ) -> List ( String, a ) -> Definition a
choice =
    Choice


init : Definition a -> Model a
init def =
    case def of
        Choice ( _, initial ) _ ->
            Model
                { currentValue = initial
                , definition = def
                }


currentValue : Model a -> a
currentValue (Model { currentValue }) =
    currentValue


view : Model a -> Html msg
view (Model { currentValue, definition }) =
    Html.div []
        [ case definition of
            Choice first rest ->
                let
                    option ( label, value ) =
                        Html.text label
                in
                    Html.select []
                        [ Html.option []
                            (List.map option (first :: rest))
                        ]
        ]
