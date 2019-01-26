module DevMain where

import           ClassyPrelude

import           Api

run :: IO ()
run = do
  putStrLn "Server is up at localhost:8080"
  startApp
