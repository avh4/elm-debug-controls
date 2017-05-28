module Controls.ComplexChoiceTest exposing (all)

import Debug.Control as Control
import Expect
import Html
import Html.Attributes as Html
import Test exposing (..)
import Test.Html.Query as Query
import Test.Html.Selector exposing (..)


type Animal
    = Monkey
    | Giraffe


maybeControls =
    Control.choice
        [ ( "Animal"
          , Control.map Just <|
                Control.choice
                    [ ( "Monkey", Control.value Monkey )
                    , ( "Giraffe", Control.value Giraffe )
                    ]
          )
        , ( "---", Control.value Nothing )
        ]


all : Test
all =
    describe "Control.choice (complex)"
        [ test "initial value is the first choice" <|
            \() ->
                maybeControls
                    |> Control.currentValue
                    |> Expect.equal (Just Monkey)
        , test "Renders all options" <|
            \() ->
                maybeControls
                    |> Control.view
                    |> Query.fromHtml
                    |> Expect.all
                        [ Query.has [ tag "option", text "Animal" ]
                        , Query.has [ tag "option", text "---" ]
                        , Query.has [ tag "option", text "Monkey" ]
                        , Query.has [ tag "option", text "Giraffe" ]
                        ]
        , test "allValues" <|
            \() ->
                maybeControls
                    |> Control.allValues
                    |> Expect.equal
                        [ Just Monkey
                        , Just Giraffe
                        , Nothing
                        ]
        ]
