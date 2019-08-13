module Controls.RecursionTest exposing (all)

import Debug.Control as Control exposing (Control)
import Expect
import Html
import Html.Attributes as Html
import Test exposing (..)
import Test.Html.Query as Query
import Test.Html.Selector exposing (..)


type RecursiveType
    = RecursiveType (Maybe RecursiveType)


controls : Control RecursiveType
controls =
    Control.choice
        [ ( "No child", Control.value Nothing )
        , ( "child", Control.lazy (\() -> controls) |> Control.map Just )
        ]
        |> Control.map RecursiveType


all : Test
all =
    describe "Control.choice (complex)"
        [ test "Initially there is no child" <|
            \() ->
                controls
                    |> Control.currentValue
                    |> Expect.equal (RecursiveType Nothing)
        , test "Renders all options" <|
            \() ->
                controls
                    |> Control.view identity
                    |> Query.fromHtml
                    |> Expect.all
                        [ Query.has [ tag "option", text "No child" ]
                        , Query.has [ tag "option", text "child" ]
                        ]
        --, test "allValues" <|
        --    \() ->
        --        controls
        --            |> Control.allValues
        --            |> Expect.equal
        --                [ RecursiveType Nothing
        --                , RecursiveType (Just (RecursiveType Nothing))
        --                ]
        ]
