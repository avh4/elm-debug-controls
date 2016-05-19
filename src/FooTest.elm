module FooTest exposing (..)

import ElmTest exposing (..)


all : Test
all =
    suite "Foo"
        [ test "is true"
            <| assertEqual 1
            <| 1
        ]
