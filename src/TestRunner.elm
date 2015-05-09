module Main where

import IO.IO exposing (..)
import IO.Runner exposing (Request, Response, run)

import ElmTest.Runner.Console exposing (runDisplay)

import AllTests

testRunner : IO ()
testRunner = runDisplay AllTests.all

port requests : Signal Request
port requests = run responses testRunner

port responses : Signal Response
