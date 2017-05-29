# elm-debug-controls

This package helps you easily build interactive UIs for complex data structures.
The resulting controls are not meant for building end-user UIs,
but they are useful for quickly building debugging consoles, documentation, and style guides.

## Demo

https://avh4.github.io/elm-debug-controls/

## Usage

Suppose we have an Elm data structure like the following and want to create a simple debugging tool to experiment with different values:

```elm
import Date exposing (Date)

type alias UploadRequest =
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
    | Update String
```

Using `elm-debug-controls`, we can quickly create an interactive UI to create `UploadRequest` values:

```sh
elm-package install avh4/elm-debug-controls
```

```elm
import Debug.Control exposing (bool, choice, field, map, record, string, value)

type alias Model =
    { ...
    , uploadRequest : Debug.Control.Control UploadRequest
    }

init : Model
init =
    { ...
    , uploadRequest =
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
            |> field "content" (string "HELLO.")
    }
```


Now we can hook the control up to our view:

```elm
type Msg
    = ...
    | ChangeUploadRequest (Debug.Control.Control UploadRequest)

update : Msg -> Model -> Model
update msg model =
    case msg of
        ...
        ChangeUploadRequest uploadRequest ->
            { model | uploadRequest = uploadRequest }

view : Model -> Html Msg
view model =
    ...
    Debug.Control.view ChangeUploadRequest model.uploadRequest
```

We now have an interactive UI that looks like this:

![Screen capture of the interactive UI](https://github.com/avh4/elm-debug-controls/raw/master/screenshot.gif)

Finally, we can use the `UploadResponse` value elsewhere in our program with:

```elm
Debug.Control.currentValue model.uploadRequest
```
