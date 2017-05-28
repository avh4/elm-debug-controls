module Main exposing (main)

import Debug.Control as Control exposing (Control)
import Html exposing (..)


type alias Model =
    { download : Control DownloadRequest
    , upload : Control UploadRequest
    }


type alias DownloadRequest =
    { path : String
    }


type alias UploadRequest =
    { path : String
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
        [ Html.map DownloadChange <| Control.view model.download
        , hr [] []
        , Html.map UploadChange <| Control.view model.upload
        ]


main : Program Never Model Msg
main =
    Html.beginnerProgram
        { model = init
        , update = update
        , view = view
        }
