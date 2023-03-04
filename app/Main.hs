module Main
  ( main
  ) where

-- import           Lib
import           Api

main :: IO ()
main = putStrLn "server started...\nhttp://localhost:8080" >> startApp
