module Main exposing (main)

import BeautifulExample
import Color
import Date exposing (Date)
import Debug.Control as Control exposing (Control)
import Html exposing (..)


type alias Model =
    { download : Control DownloadRequest
    , upload : Control UploadRequest
    }


type alias DownloadRequest =
    { path : String
    }


type WriteMode
    = Add
    | Overwrite
    | Update String


type alias UploadRequest =
    { path : String
    , mode : WriteMode
    , autorename : Bool
    , clientModified : Maybe Date
    , mute : Bool
    , content : String
    }


init : Model
init =
    { download =
        Control.record DownloadRequest
            |> Control.field "path" (Control.string "/demo.txt")
    , upload =
        Control.record UploadRequest
            |> Control.field "path" (Control.string "/demo.txt")
            |> Control.field "mode"
                (Control.choice
                    [ ( "Add", Control.value Add )
                    , ( "Overwrite", Control.value Overwrite )
                    , ( "Update rev", Control.map Update <| Control.string "123abcdef" )
                    ]
                )
            |> Control.field "autorename" (Control.bool False)
            |> Control.field "clientModified"
                (Control.maybe False <| Control.date <| Date.fromTime 0)
            |> Control.field "mute" (Control.bool False)
            |> Control.field "content" (Control.string "HELLO.")
    }


type Msg
    = DownloadChange (Control DownloadRequest)
    | UploadChange (Control UploadRequest)


update : Msg -> Model -> Model
update msg model =
    case msg of
        DownloadChange download ->
            { model | download = download }

        UploadChange upload ->
            { model | upload = upload }


view : Model -> Html Msg
view model =
    Html.div []
        [ h2 [] [ text "Download" ]
        , p []
            [ text "We have the following "
            , code [] [ text "DownloadRequest" ]
            , text " data type:"
            ]
        , pre []
            [ text """type alias DownloadRequest =
    { path : String
    }"""
            ]
        , p [] [ text "An interactive control can be created with the following code:" ]
        , pre [] [ text """import Debug.Control exposing (field, record, string)

record DownloadRequest
    |> field "path" (string "/demo.txt")""" ]
        , Control.view DownloadChange model.download
        , h2 [] [ text "Upload" ]
        , p []
            [ text "We have the following "
            , code [] [ text "DownloadRequest" ]
            , text " data type:"
            ]
        , pre []
            [ text """type alias UploadRequest =
    { path : String
    , mode : WriteMode
    , autorename : Bool
    , clientModified : Maybe Date
    , mute : Bool
    , content : String
    }

type WriteMode
    = Add
    | Overwrite
    | Update String"""
            ]
        , p [] [ text "An interactive control can be created with the following code:" ]
        , pre [] [ text """import Debug.Control exposing (bool, choice, field, map, record, string, value)

record UploadRequest
    |> field "path" (string "/demo.txt")
    |> field "mode"
        (choice
            [ ( "Add", value Add )
            , ( "Overwrite", value Overwrite )
            , ( "Update rev", map Update <| string "123abcdef" )
            ]
        )
    |> field "autorename" (bool False)
    |> field "clientModified"
        (maybe False <| date <| Date.fromTime 0)
    |> field "mute" (bool False)
    |> field "content" (string "HELLO.")""" ]
        , Control.view UploadChange model.upload
        ]


main : Program Never Model Msg
main =
    BeautifulExample.beginnerProgram
        { title = "elm-debug-controls"
        , details = Just """This package helps you easily create interactive and exhaustive views of complex data structures."""
        , color = Just Color.brown
        , maxWidth = 600
        , githubUrl = Just "https://github.com/avh4/elm-debug-controls"
        , documentationUrl = Just "http://packages.elm-lang.org/packages/avh4/elm-debug-controls/latest"
        }
        { model = init
        , update = update
        , view = view
        }
