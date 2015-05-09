module FooTest where

import ElmTest.Assertion exposing (..)
import ElmTest.Test exposing (..)

suite = Suite "Foo"
  [ test "is true" <|
      1
      `assertEqual`
      1
  ]
