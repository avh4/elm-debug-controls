module FooTest where

import ElmTest.Assertion (..)
import ElmTest.Test (..)

suite = Suite "Foo"
  [ test "is true" <|
      1
      `assertEqual`
      1
  ]
