module Controls
    exposing
        ( Control
        , allValues
        , choice
        , currentValue
        , list
        , map
        , string
        , value
        , values
        , view
        )

import Html exposing (Html)
import Html.Attributes
import Html.Events
import Json.Decode
import String


type Control a
    = Control
        { currentValue : a
        , allValues : () -> List a
        , view : () -> Html (Control a)
        }


value : a -> Control a
value initial =
    Control
        { currentValue = initial
        , allValues = \() -> [ initial ]
        , view = \() -> Html.text ""
        }


values : List a -> Control a
values choices =
    choice (List.map (\x -> ( toString x, value x )) choices)


string : String -> Control String
string value =
    Control
        { currentValue = value
        , allValues =
            \() ->
                [ value
                , ""
                , "short"
                , "Longwordyesverylongwithnospacessupercalifragilisticexpialidocious"
                , "Long text lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
                ]
        , view =
            \() ->
                Html.input
                    [ Html.Attributes.value value
                    , Html.Events.onInput string
                    ]
                    []
        }


choice : List ( String, Control a ) -> Control a
choice choices =
    case choices of
        [] ->
            Debug.crash "No choices given"

        first :: rest ->
            choice_ [] first rest


choice_ :
    List ( String, Control a )
    -> ( String, Control a )
    -> List ( String, Control a )
    -> Control a
choice_ left current right =
    Control
        { currentValue = current |> Tuple.second |> currentValue
        , allValues =
            \() ->
                (List.reverse left ++ [ current ] ++ right)
                    |> List.map (Tuple.second >> allValues)
                    |> List.concat
        , view =
            \() ->
                let
                    option selected ( label, value ) =
                        Html.option
                            [ Html.Attributes.selected selected ]
                            [ Html.text label ]

                    selectNew i =
                        let
                            all =
                                List.reverse left
                                    ++ [ current ]
                                    ++ right

                            left_ =
                                all
                                    |> List.take i
                                    |> List.reverse

                            current_ =
                                all
                                    |> List.drop i
                                    |> List.head
                                    |> Maybe.withDefault current

                            right_ =
                                all
                                    |> List.drop (i + 1)
                        in
                        choice_ left_ current_ right_ |> Debug.log "new"

                    updateChild new =
                        choice_ left ( Tuple.first current, new ) right
                in
                Html.div []
                    [ Html.map selectNew <|
                        Html.select
                            [ Html.Events.on "change" (Json.Decode.at [ "target", "selectedIndex" ] Json.Decode.int)
                            ]
                        <|
                            List.concat
                                [ List.map (option False) <| List.reverse left
                                , [ option True current ]
                                , List.map (option False) right
                                ]
                    , Html.map updateChild <|
                        view (Tuple.second current)
                    ]
        }


list : Control a -> Control (List a)
list itemControl =
    list_ itemControl 1 0 10


list_ : Control a -> Int -> Int -> Int -> Control (List a)
list_ itemControl current min max =
    let
        makeList n =
            allValues itemControl
                |> List.repeat n
                |> List.concat
                |> List.take n
    in
    Control
        { currentValue = makeList current
        , allValues =
            \() ->
                [ 1, 0, 3 ]
                    |> List.filter (\x -> x > min && x < max)
                    |> flip List.append [ min, max ]
                    |> List.map makeList
        , view =
            \() ->
                let
                    selectNew new =
                        list_ itemControl new min max
                in
                Html.map
                    (String.toInt
                        >> Result.toMaybe
                        >> Maybe.withDefault current
                        >> selectNew
                    )
                <|
                    Html.label []
                        [ Html.text ""
                        , Html.input
                            [ Html.Attributes.type_ "range"
                            , Html.Attributes.min <| toString min
                            , Html.Attributes.max <| toString max
                            , Html.Attributes.step <| toString 1
                            , Html.Attributes.attribute "value" <| toString current
                            , Html.Events.on "input" Html.Events.targetValue
                            ]
                            []
                        ]
        }


map : (a -> b) -> Control a -> Control b
map fn (Control { currentValue, allValues, view }) =
    let
        mapTuple ( label, value ) =
            ( label, map fn value )
    in
    Control
        { currentValue = fn currentValue
        , allValues = \() -> List.map fn (allValues ())
        , view = \() -> Html.map (map fn) (view ())
        }


currentValue : Control a -> a
currentValue (Control c) =
    c.currentValue


allValues : Control a -> List a
allValues (Control c) =
    c.allValues ()


view : Control a -> Html (Control a)
view (Control c) =
    c.view ()
