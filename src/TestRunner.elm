module Main where

import IO.IO (..)
import IO.Runner (Request, Response, run)

import ElmTest.Runner.Console (runDisplay)

import AllTests

testRunner : IO ()
testRunner = runDisplay AllTests.all

port requests : Signal Request
port requests = run responses testRunner

port responses : Signal Response
