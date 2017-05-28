module Controls.SimpleChoiceTest exposing (all)

import Debug.Control as Control
import Expect
import Html
import Html.Attributes as Html
import Test exposing (..)
import Test.Html.Query as Query
import Test.Html.Selector exposing (..)


yesNoControls =
    Control.choice
        [ ( "YES", Control.value True )
        , ( "NO", Control.value False )
        ]


all : Test
all =
    describe "Control.choice"
        [ test "initial value is the first choice" <|
            \() ->
                yesNoControls
                    |> Control.currentValue
                    |> Expect.equal True
        , test "Renders all options" <|
            \() ->
                yesNoControls
                    |> Control.view identity
                    |> Query.fromHtml
                    |> Expect.all
                        [ Query.has [ tag "option", text "YES" ]
                        , Query.has [ tag "option", text "NO" ]
                        ]
        ]
