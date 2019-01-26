module Main where

import           ClassyPrelude

import           Api

main :: IO ()
main = do
  putStrLn "Server is up at localhost:8080"
  startApp
