module Main exposing (main)

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
                    , ( "Update", Control.map Update <| Control.string "123abcdef" )
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
        [ Control.view DownloadChange model.download
        , hr [] []
        , Control.view UploadChange model.upload
        ]


main : Program Never Model Msg
main =
    Html.beginnerProgram
        { model = init
        , update = update
        , view = view
        }
