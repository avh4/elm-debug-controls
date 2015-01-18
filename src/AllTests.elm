module AllTests where

import ElmTest.Assertion (..)
import ElmTest.Test (..)

import FooTest

all = Suite "outlin"
  [ FooTest.suite
  ]
