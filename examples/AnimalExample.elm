module AnimalExample exposing (..)

import Debug.Control exposing (Control, choice, list, map, string, value, values)
import Html exposing (Html)
import Html.Attributes as Html exposing (style)
import String


type Animal
    = Monkey
    | Giraffe
    | Eagle
    | Chimera (List Animal)
    | CustomAnimal String


debugControl : Control (Maybe Animal)
debugControl =
    let
        basicAnimal =
            values [ Monkey, Giraffe, Eagle ]
    in
    choice
        [ ( "Animal", map Just basicAnimal )
        , ( "Chimera", map (Just << Chimera) (list basicAnimal) )
        , ( "Custom", map (Just << CustomAnimal) (string "Zebra") )
        , ( "Nothing", value Nothing )
        ]


viewAnimal : Int -> Maybe Animal -> Html msg
viewAnimal size animal =
    let
        svg url =
            Html.img
                [ Html.style
                    [ ( "width", toString size ++ "px" )
                    , ( "height", toString size ++ "px" )
                    , ( "overflow", "hidden" )
                    , ( "vertical-align", "bottom" )
                    ]
                , Html.src url
                , Html.width size
                ]
                []

        letters background color string =
            Html.div
                [ Html.style
                    [ ( "width", toString size ++ "px" )
                    , ( "height", toString size ++ "px" )
                    , ( "background-color", background )
                    , ( "color", color )
                    , ( "overflow", "hidden" )
                    , ( "text-overflow", "ellipsis" )
                    , ( "line-height", toString size ++ "px" )
                    , ( "text-align", "center" )
                    , ( "font-family", "sans-serif" )
                    ]
                ]
                [ Html.text string ]
    in
    case animal of
        Just Monkey ->
            svg "monkey.svg"

        Just Giraffe ->
            svg "giraffe.svg"

        Just Eagle ->
            svg "eagle.svg"

        Just (CustomAnimal name) ->
            name
                |> String.split " "
                |> List.map (String.left 1)
                |> String.join ""
                |> String.toUpper
                |> letters "pink" "black"

        Just (Chimera parts) ->
            let
                scale =
                    List.length parts
                        |> toFloat
                        |> sqrt
                        |> ceiling
            in
            Html.div
                [ Html.style
                    [ ( "width", toString size ++ "px" )
                    , ( "height", toString size ++ "px" )
                    , ( "background-color", "lightgreen" )
                    , ( "line-height", "0" )
                    ]
                ]
                (List.map (Just >> viewAnimal (size // scale)) parts)

        Nothing ->
            letters "lightgray" "gray" "N/A"


view : Control (Maybe Animal) -> Html (Control (Maybe Animal))
view control =
    let
        h title =
            Html.h2 [] [ Html.text title ]

        showData data =
            Html.table []
                [ Html.tr []
                    [ Html.td [] [ viewAnimal 50 data ]
                    , Html.td []
                        [ Html.code
                            [ style [ ( "word-break", "break-all" ) ] ]
                            [ Html.text (toString data) ]
                        ]
                    ]
                ]
    in
    Html.div []
        [ h "Example data structure"
        , Html.pre []
            [ Html.text """type Animal
    = Monkey
    | Giraffe
    | Eagle
    | Chimera (List Animal)
    | CustomAnimal String"""
            ]
        , h "Interactive control"
        , Debug.Control.view identity control
        , showData (Debug.Control.currentValue control)
        , h "All possible values"
        , List.map showData (Debug.Control.allValues control)
            |> Html.div []
        , Html.hr [] []
        , Html.a [ Html.href "https://github.com/avh4/elm-debug-controls/blob/master/examples/LICENSE.md#images" ]
            [ Html.text "Image credits" ]
        ]
