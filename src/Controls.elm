module Controls
    exposing
        ( value
        , values
        , string
        , choice
        , list
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
import String


type Control a
    = Value a
    | Text (String -> a) String
    | Choice
        { left : List ( String, Control a )
        , current : ( String, Control a )
        , right : List ( String, Control a )
        }
    | Slider (Int -> a) Int { min : Int, max : Int }


value : a -> Control a
value initial =
    Value initial


values : List a -> Control a
values choices =
    choice (List.map (\x -> ( toString x, value x )) choices)


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


list : Control a -> Control (List a)
list itemControl =
    let
        makeList n =
            allValues itemControl
                |> List.repeat n
                |> List.concat
                |> List.take n
    in
        Slider makeList 1 { min = 0, max = 10 }


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

            Text fn0 current ->
                Text (fn0 >> fn) current

            Value current ->
                Value (fn current)

            Slider fn0 current range ->
                Slider (fn0 >> fn) current range


currentValue : Control a -> a
currentValue control =
    case control of
        Value current ->
            current

        Text fn current ->
            fn current

        Choice { current } ->
            currentValue (snd current)

        Slider fn current _ ->
            fn current


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

        Slider fn _ { min, max } ->
            [ 1, 0, 3 ]
                |> List.filter (\x -> x > min && x < max)
                |> flip List.append [ min, max ]
                |> List.map fn


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
                        [ Html.map selectNew <|
                            Html.select
                                [ Html.on "change" (Json.Decode.at [ "target", "selectedIndex" ] Json.Decode.int)
                                ]
                            <|
                                List.concat
                                    [ List.map (option False) <| List.reverse left
                                    , [ option True current ]
                                    , List.map (option False) right
                                    ]
                        , Html.map updateChild <|
                            view (snd current)
                        ]

            Text fn text ->
                Html.input
                    [ Html.value text
                    , Html.onInput (Text fn)
                    ]
                    []

            Value _ ->
                Html.text ""

            Slider fn current range ->
                let
                    selectNew new =
                        Slider fn
                            new
                            range
                in
                    Html.map
                        (String.toInt
                            >> Result.toMaybe
                            >> Maybe.withDefault 1
                            >> selectNew
                        )
                    <|
                        Html.label []
                            [ Html.text ""
                            , Html.input
                                [ Html.type' "range"
                                , Html.min <| toString range.min
                                , Html.max <| toString range.max
                                , Html.step <| toString 1
                                , Html.attribute "value" <| toString current
                                , Html.on "input" Html.targetValue
                                ]
                                []
                            ]
        ]
