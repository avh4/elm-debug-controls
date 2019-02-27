module Controls.StringTest exposing (all)

import Debug.Control as Control
import Expect
import Html
import Html.Attributes as Html
import Test exposing (..)
import Test.Html.Query as Query
import Test.Html.Selector exposing (..)


stringControls =
    Control.string "default"


all : Test
all =
    describe "Control.string"
        [ test "initial value" <|
            \() ->
                stringControls
                    |> Control.currentValue
                    |> Expect.equal "default"
        , test "Renders all options" <|
            \() ->
                stringControls
                    |> Control.view identity
                    |> Query.fromHtml
                    |> Query.has [ tag "input", attribute (Html.value "default") ]
        ]
