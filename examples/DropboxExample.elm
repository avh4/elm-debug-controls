module DropboxExample exposing (Model, Msg, init, update, view)

import Debug.Control as Control exposing (Control)
import Html exposing (..)
import Time


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
    , clientModified : Maybe Time.Posix
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
                (Control.maybe False <| Control.date Time.utc <| Time.millisToPosix 0)
            |> Control.field "mute" (Control.bool False)
            |> Control.field "content"
                (Control.longString
                    """I do much wonder that one man, seeing how much
another man is a fool when he dedicates his
behaviors to love, will, after he hath laughed at
such shallow follies in others, become the argument
of his own scorn by failing in love: and such a man
is Claudio. I have known when there was no music
with him but the drum and the fife; and now had he
rather hear the tabour and the pipe: I have known
when he would have walked ten mile a-foot to see a
good armour; and now will he lie ten nights awake,
carving the fashion of a new doublet.
"""
                )
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
    , clientModified : Maybe Time.Posix
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
        (maybe False <| date Tim.utc <| Time.millisToPosix 0)
    |> field "mute" (bool False)
    |> field "content"
        (Control.longString
            \"\"\"I do much wonder that one man, seeing how much
another man is a fool when he dedicates his
behaviors to love, will, after he hath laughed at
such shallow follies in others, become the argument
of his own scorn by failing in love: and such a man
is Claudio. I have known when there was no music
with him but the drum and the fife; and now had he
rather hear the tabour and the pipe: I have known
when he would have walked ten mile a-foot to see a
good armour; and now will he lie ten nights awake,
carving the fashion of a new doublet.
\"\"\"
        )
                """ ]
        , Control.view UploadChange model.upload
        ]
