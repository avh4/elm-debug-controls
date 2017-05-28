module Main exposing (main)

import Debug.Control as Control exposing (Control)
import Html exposing (..)


type alias Model =
    { download : Control DownloadRequest

    --, upload : Control UploadRequest
    }


type alias DownloadRequest =
    { path : String
    }


init : Model
init =
    { download =
        Control.record DownloadRequest
            |> Control.field "path" (Control.string "/demo.txt")
    }


type Msg
    = DownloadChange (Control DownloadRequest)


update : Msg -> Model -> Model
update msg model =
    case msg of
        DownloadChange download ->
            { model | download = download }


view : Model -> Html Msg
view model =
    Html.map DownloadChange <| Control.view model.download


main : Program Never Model Msg
main =
    Html.beginnerProgram
        { model = init
        , update = update
        , view = view
        }
