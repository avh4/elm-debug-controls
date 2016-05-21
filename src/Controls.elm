module Controls
    exposing
        ( value
        , string
        , choice
        , map
        , currentValue
        , allValues
        , view
        )

import Html exposing (Html)
import Html.Attributes as Html
import Html.Events as Html
import Html.App as Html
import Json.Decode


type Control a
    = Value a
    | Text (String -> a) String
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
    Text identity initial


choice : List ( String, Control a ) -> Control a
choice choices =
    case choices of
        [] ->
            Debug.crash "No choices given"

        first :: rest ->
            Choice
                { left = []
                , current = first
                , right = rest
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

            Text fn0 initial ->
                Text (fn0 >> fn) initial

            Value initial ->
                Value (fn initial)


currentValue : Control a -> a
currentValue control =
    case control of
        Value current ->
            current

        Text fn current ->
            fn current

        Choice { current } ->
            currentValue (snd current)


allValues : Control a -> List a
allValues control =
    case control of
        Value current ->
            [ current ]

        Text fn current ->
            [ fn current
            , fn ""
            , fn "short"
            , fn "Longwordyesverylongwithnospacessupercalifragilisticexpialidocious"
            , fn "Long text lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
            ]

        Choice { left, current, right } ->
            (List.reverse left ++ [ current ] ++ right)
                |> List.map (snd >> allValues)
                |> List.concat


view : Control a -> Html (Control a)
view control =
    Html.div []
        [ case control of
            Choice { left, current, right } ->
                let
                    option selected ( label, value ) =
                        Html.option [ Html.selected selected ]
                            [ Html.text label
                            ]

                    selectNew i =
                        let
                            all =
                                (List.reverse left)
                                    ++ [ current ]
                                    ++ right
                        in
                            Choice
                                { left =
                                    all
                                        |> List.take i
                                        |> List.reverse
                                , current =
                                    all
                                        |> List.drop i
                                        |> List.head
                                        |> Maybe.withDefault current
                                , right =
                                    all
                                        |> List.drop (i + 1)
                                }

                    updateChild new =
                        Choice
                            { left = left
                            , current = ( fst current, new )
                            , right = right
                            }
                in
                    Html.div []
                        [ Html.map selectNew
                            <| Html.select
                                [ Html.on "change" (Json.Decode.at [ "target", "selectedIndex" ] Json.Decode.int)
                                ]
                            <| List.concat
                                [ List.map (option False) <| List.reverse left
                                , [ option True current ]
                                , List.map (option False) right
                                ]
                        , Html.map updateChild
                            <| view (snd current)
                        ]

            Text fn text ->
                Html.input
                    [ Html.value text
                    , Html.onInput (Text fn)
                    ]
                    []

            Value _ ->
                Html.text ""
        ]
