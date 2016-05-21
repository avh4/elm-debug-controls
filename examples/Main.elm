module Main exposing (..)

import Html
import Html.Attributes as Html
import Html.App
import Controls exposing (choice, string, value, values, list, map)
import String


type Animal
    = Monkey
    | Giraffe
    | Eagle
    | Chimera (List Animal)
    | CustomAnimal String


def1 =
    string "default value"


def2 =
    choice
        [ ( "YES", value True )
        , ( "NO", value False )
        ]


def3 =
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


view model =
    let
        h title =
            Html.h2 [] [ Html.text title ]

        showData data =
            Html.table []
                [ Html.tr []
                    [ Html.td [] [ viewAnimal 50 data ]
                    , Html.td [] [ Html.pre [] [ Html.text (toString data) ] ]
                    ]
                ]
    in
        Html.div [ Html.style [ ( "padding", "24px" ) ] ]
            [ Html.a [ Html.href "https://github.com/avh4/elm-debug-controls/" ] [ Html.text "https://github.com/avh4/elm-debug-controls/" ]
            , h "Interactive control"
            , Controls.view model
            , showData (Controls.currentValue model)
            , h "All possible values"
            , List.map showData (Controls.allValues model)
                |> Html.div []
            , Html.hr [] []
            , Html.a [ Html.href "https://github.com/avh4/elm-debug-controls/blob/master/examples/LICENSE.md#images" ]
                [ Html.text "Image credits" ]
            ]


main =
    Html.App.beginnerProgram
        { model = def3
        , view = view
        , update = always
        }
