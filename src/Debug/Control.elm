module Debug.Control
    exposing
        ( Control
        , allValues
        , bool
        , choice
        , currentValue
        , date
        , field
        , list
        , map
        , record
        , string
        , value
        , values
        , view
        )

{-| Create interactive controls for complex data structures.

@docs Control
@docs value
@docs bool, string, date
@docs values, choice, list, record, field
@docs map

@docs view, currentValue, allValues

-}

import Css
import Date exposing (Date)
import DateTimePicker
import DateTimePicker.Css
import Html exposing (Html)
import Html.Attributes
import Html.CssHelpers
import Html.Events
import Json.Decode
import String


{-| An interactive control that produces a value `a`.
-}
type Control a
    = Control
        { currentValue : a
        , allValues : () -> List a
        , view : () -> Html (Control a)
        }


{-| A `Control` that has a static value.
-}
value : a -> Control a
value initial =
    Control
        { currentValue = initial
        , allValues = \() -> [ initial ]
        , view = \() -> Html.text ""
        }


{-| A `Control` that chooses between a list of values.
-}
values : List a -> Control a
values choices =
    choice (List.map (\x -> ( toString x, value x )) choices)


{-| A `Control` that toggles a `Bool` with a checkbox
-}
bool : Bool -> Control Bool
bool value =
    Control
        { currentValue = value
        , allValues =
            \() ->
                [ value
                , not value
                ]
        , view =
            \() ->
                Html.span []
                    [ Html.input
                        [ Html.Attributes.type_ "checkbox"
                        , Html.Events.onCheck bool
                        , Html.Attributes.checked value
                        ]
                        []
                    , Html.text " "
                    , Html.text <| toString value
                    ]
        }


{-| A `Control` that allows text input.
-}
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


{-| A `Control` that allows a Date (include date and time) input
with a date picker.
-}
date : Date -> Control Date
date value =
    date_ DateTimePicker.initialState value


date_ : DateTimePicker.State -> Date -> Control Date
date_ state value =
    Control
        { currentValue = value
        , allValues = \() -> [ value ] -- TODO
        , view =
            \() ->
                Html.span []
                    [ DateTimePicker.dateTimePicker
                        (\newState newDate ->
                            case newDate of
                                Nothing ->
                                    date_ newState value

                                Just d ->
                                    date_ newState d
                        )
                        []
                        state
                        (Just value)
                    ]
        }


{-| A `Control` that chooses between a list of nested controls

This will crash if you provide an empty list.

-}
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


{-| A `Control` that provides a list of selected length.
-}
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


{-| Create a `Control` representing a record with multiple fields.

This uses an API similar to [elm-decode-pipeline](http://package.elm-lang.org/packages/NoRedInk/elm-decode-pipeline/latest).

You will use this with `field`.

    import Debug.Control exposing (field, record, string)

    type alias Point =
        { x : String
        , y : String
        }

    pointControl : Control Point
    pointControl =
        record Point
            |> field "x" (string "initial x value")
            |> field "y" (string "initial y value")

-}
record : a -> Control a
record fn =
    Control
        { currentValue = fn
        , allValues = \() -> [ fn ]
        , view = \() -> Html.text ""
        }


{-| Used with `record` to create a `Control` representing a record.

See [`record`](#record).

-}
field : String -> Control a -> Control (a -> b) -> Control b
field name (Control value) (Control pipeline) =
    Control
        { currentValue = pipeline.currentValue value.currentValue
        , allValues =
            \() ->
                value.allValues ()
                    |> List.concatMap
                        (\v ->
                            List.map (\p -> p v)
                                (pipeline.allValues ())
                        )
        , view =
            \() ->
                Html.div []
                    [ Html.map (field name (Control value)) <|
                        pipeline.view ()
                    , Html.div []
                        [ Html.text name
                        , Html.text " = "
                        , Html.map (\v -> field name v (Control pipeline)) <|
                            value.view ()
                        ]
                    ]
        }


{-| Transform the value produced by a `Control`.
-}
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


{-| TODO: revise API
-}
currentValue : Control a -> a
currentValue (Control c) =
    c.currentValue


{-| TODO: revise API
-}
allValues : Control a -> List a
allValues (Control c) =
    c.allValues ()


{-| TODO: revise API
-}
view : Control a -> Html (Control a)
view (Control c) =
    Html.div []
        [ [ DateTimePicker.Css.css ]
            |> Css.compile
            |> .css
            |> Html.CssHelpers.style
        , c.view ()
        ]
