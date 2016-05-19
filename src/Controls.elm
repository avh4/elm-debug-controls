module Controls
    exposing
        ( string
        , choice
        , init
        , currentValue
        , view
        )

import Html exposing (Html)
import Html.Attributes as Html


type Definition a msg
    = Choice ( String, a ) (List ( String, a ))
    | Value a (a -> Html msg)


type Model a msg
    = Model
        { currentValue : a
        , definition : Definition a msg
        }


string : String -> Definition String msg
string initial =
    let
        view value =
            Html.input
                [ Html.value "default"
                ]
                []
    in
        Value initial view


choice : ( String, a ) -> List ( String, a ) -> Definition a msg
choice =
    Choice


init : Definition a msg -> Model a msg
init def =
    case def of
        Choice ( _, initial ) _ ->
            Model
                { currentValue = initial
                , definition = def
                }

        Value initial _ ->
            Model
                { currentValue = initial
                , definition = def
                }


currentValue : Model a msg -> a
currentValue (Model { currentValue }) =
    currentValue


view : Model a msg -> Html msg
view (Model { currentValue, definition }) =
    Html.div []
        [ case definition of
            Choice first rest ->
                let
                    option ( label, value ) =
                        Html.option []
                            [ Html.text label
                            ]
                in
                    Html.select []
                        (List.map option (first :: rest))

            Value _ view ->
                view currentValue
        ]
