module Controls.DateTest exposing (all)

import Debug.Control as Control
import Expect
import Html
import Html.Attributes as Html
import Test exposing (..)
import Test.Html.Query as Query
import Test.Html.Selector exposing (..)
import Time
import Time.Extra


all : Test
all =
    describe "Control.date"
        [ test "epoch initial value" <|
            \() ->
                Control.date Time.utc (Time.millisToPosix 0)
                    |> Control.currentValue
                    |> Expect.equal (Time.millisToPosix 0)
        , test "other initial value" <|
            \() ->
                Control.date Time.utc (Time.millisToPosix 1425744000000)
                    |> Control.currentValue
                    |> Expect.equal (Time.millisToPosix 1425744000000)
        ]
