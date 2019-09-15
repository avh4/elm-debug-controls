module Controls.StringTest exposing (all)

import Debug.Control as Control
import Expect
import Html
import Html.Attributes as Html
import Test exposing (..)
import Test.Html.Query as Query
import Test.Html.Selector exposing (..)


all : Test
all =
    describe "Text"
        [ describe "Control.string"
            [ test "initial value" <|
                \() ->
                    Control.string "default"
                        |> Control.currentValue
                        |> Expect.equal "default"
            , test "Renders all options" <|
                \() ->
                    Control.string "default"
                        |> Control.view identity
                        |> Query.fromHtml
                        |> Query.has [ tag "input", attribute (Html.value "default") ]
            ]
        , describe "Control.stringTextarea"
            [ test "initial value" <|
                \() ->
                    Control.stringTextarea "long default"
                        |> Control.currentValue
                        |> Expect.equal "long default"
            , test "Renders all options" <|
                \() ->
                    Control.stringTextarea "long default"
                        |> Control.view identity
                        |> Query.fromHtml
                        |> Query.has [ tag "textarea", attribute (Html.value "long default") ]
            ]
        ]
