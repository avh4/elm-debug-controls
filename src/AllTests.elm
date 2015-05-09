module AllTests where

import ElmTest.Assertion exposing (..)
import ElmTest.Test exposing (..)

import FooTest

all = Suite "outlin"
  [ FooTest.suite
  ]
