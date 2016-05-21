module Controls
    exposing
        ( value
        , string
        , choice
        , map
        , currentValue
        , view
        )

import Html exposing (Html)
import Html.Attributes as Html


type Control a
    = Value a
    | Text String (String -> a)
    | Choice
        { left : List ( String, Control a )
        , current : ( String, Control a )
        , right : List ( String, Control a )
        }


value : a -> Control a
value initial =
    Value initial


string : String -> Control String
string initial =
    Text initial identity


choice :
    ( String, Control a )
    -> List ( String, Control a )
    -> Control a
choice current right =
    Choice
        { left = []
        , current = current
        , right = right
        }


map : (a -> b) -> Control a -> Control b
map fn source =
    let
        mapTuple ( label, value ) =
            ( label, map fn value )
    in
        case source of
            Choice { left, current, right } ->
                Choice
                    { left = List.map mapTuple left
                    , current = mapTuple current
                    , right = List.map mapTuple right
                    }

            Text initial fn0 ->
                Text initial (fn0 >> fn)

            Value initial ->
                Value (fn initial)


currentValue : Control a -> a
currentValue control =
    case control of
        Value current ->
            current

        Text current fn ->
            fn current

        Choice { current } ->
            currentValue (snd current)


view : Control a -> Html a
view control =
    Html.div []
        [ case control of
            Choice { left, current, right } ->
                let
                    option selected ( label, value ) =
                        Html.option [ Html.selected selected ]
                            [ Html.text label
                            ]
                in
                    Html.div []
                        [ Html.select []
                            <| List.concat
                                [ List.map (option False) <| List.reverse left
                                , [ option True current ]
                                , List.map (option False) right
                                ]
                        , view (snd current)
                        ]

            Text _ fn ->
                Html.input
                    [ Html.value "default"
                    ]
                    []

            Value _ ->
                Html.text ""
        ]
