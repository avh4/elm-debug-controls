module Main exposing (Model, Msg(..), WhichExample(..), choiceControl, initialModel, main, stringControl, update, view)

import AnimalExample
import BeautifulExample
import Color
import Debug.Control exposing (Control, choice, list, map, string, value, values)
import DropboxExample
import Html exposing (..)
import Html.Events exposing (onClick)


stringControl : Control String
stringControl =
    string "default value"


choiceControl : Control Bool
choiceControl =
    choice
        [ ( "YES", value True )
        , ( "NO", value False )
        ]


type WhichExample
    = Animal
    | Dropbox
    | SimpleControls


type alias Model =
    { which : WhichExample
    , animal : Control (Maybe AnimalExample.Animal)
    , dropbox : DropboxExample.Model
    , choice : Control Bool
    , string : Control String
    }


initialModel : Model
initialModel =
    { which = Dropbox
    , animal = AnimalExample.debugControl
    , dropbox = DropboxExample.init
    , choice = choiceControl
    , string = stringControl
    }


type Msg
    = SwitchTo WhichExample
    | ChangeAnimal (Control (Maybe AnimalExample.Animal))
    | DropboxMsg DropboxExample.Msg
    | ChangeChoice (Control Bool)
    | ChangeString (Control String)


update : Msg -> Model -> Model
update msg model =
    case msg of
        SwitchTo which ->
            { model | which = which }

        ChangeAnimal animal ->
            { model | animal = animal }

        DropboxMsg dropboxMsg ->
            { model | dropbox = DropboxExample.update dropboxMsg model.dropbox }

        ChangeChoice choice ->
            { model | choice = choice }

        ChangeString string ->
            { model | string = string }


view : Model -> Html Msg
view model =
    div []
        [ button [ onClick (SwitchTo Dropbox) ] [ text "Records example (Upload/Download)" ]
        , br [] []
        , button [ onClick (SwitchTo Animal) ] [ text "Union type example (Animal)" ]
        , br [] []
        , button [ onClick (SwitchTo SimpleControls) ] [ text "Simple controls" ]
        , br [] []
        , case model.which of
            Animal ->
                AnimalExample.view model.animal
                    |> Html.map ChangeAnimal

            Dropbox ->
                DropboxExample.view model.dropbox
                    |> Html.map DropboxMsg

            SimpleControls ->
                div []
                    [ h3 [] [ text "choice" ]
                    , Debug.Control.view ChangeChoice model.choice
                    , h3 [] [ text "string" ]
                    , Debug.Control.view ChangeString model.string
                    ]
        ]


main : Program () Model Msg
main =
    BeautifulExample.sandbox
        { title = "elm-debug-controls"
        , details = Just """This package helps you easily create interactive and exhaustive views of complex data structures."""
        , color = Just Color.brown
        , maxWidth = 600
        , githubUrl = Just "https://github.com/avh4/elm-debug-controls"
        , documentationUrl = Just "http://package.elm-lang.org/packages/avh4/elm-debug-controls/latest"
        }
        { init = initialModel
        , update = update
        , view = view
        }
