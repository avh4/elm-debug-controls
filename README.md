
Here's an example of defining a control for a complicated `Animal` data type:

```elm
type Animal
    = Monkey
    | Giraffe
    | Eagle
    | Chimera (List Animal)
    | CustomAnimal String

debugControl =
    let
        basicAnimal =
            values [ Monkey, Giraffe, Eagle ]
    in
        choice
            [ ( "Animal", map Just basicAnimal )
            , ( "Chimera", map (Just << Chimera) (list basicAnimal) )
            , ( "Custom", map (Just << CustomAnimal) (string "Zebra") )
            , ( "Nothing", value Nothing )
            ]
```

You can now use `debugControl` to create an interactve control the generate data, or to create an exhaustive list of all possible data.  You can see what this looks like at http://avh4.github.io/elm-debug-controls/examples/

```elm
view control =
    Html.div []
        [ -- Interactive control
          Controls.view control
        , showData (Controls.currentValue control)
        , -- All possible values
          List.map showData (Controls.allValues control)
            |> Html.div []
        ]

main =
    Html.App.beginnerProgram
        { model = debugControl
        , view = view
        , update = \msg _ -> msg
        }
```
