{-# LANGUAGE OverloadedStrings #-}

module Database where

import           Database.SQLite.Simple

import           Const
import           Types

addTest :: String -> IO Integer
addTest tableName = withConnection dbName $ \conn ->
  execute conn "INSERT INTO tests(title) VALUES (?)" (Only tableName)
    >>  toInteger
    <$> lastInsertRowId conn

getTests :: IO [Test]
getTests = withConnection dbName $ \conn -> query_ conn "SELECT * FROM tests;"

testTests :: [Test]
testTests = [Test 1 "Test 1", Test 2 "Test 2", Test 3 "Test 3"]


