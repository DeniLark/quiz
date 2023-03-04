{-# LANGUAGE OverloadedStrings #-}

module Database where

import qualified Data.Text                     as T
import           Database.SQLite.Simple

import           Const
import           Types


addTest :: TestInput -> IO ()
addTest (TestInput titleTI questions) = do
  idTest <- addTest' titleTI
  mapM_ (addQuestion idTest) questions

addQuestion :: Integer -> Question -> IO ()
addQuestion idTest (Question titleQ answers) = do
  idQuestion <- addQuestion' idTest titleQ
  mapM_ (addAnswer idQuestion) answers

addAnswer :: Integer -> Answer -> IO ()
addAnswer idQuestion (Answer textA isC) = withConnection dbName $ \conn ->
  execute
    conn
    "INSERT INTO answers(question_id, textAnswer, isCorrect) VALUES (?, ?, ?)"
    (idQuestion, textA, isC)

addQuestion' :: Integer -> T.Text -> IO Integer
addQuestion' testId titleQ = withConnection dbName $ \conn ->
  execute conn
          "INSERT INTO questions(test_id, textQuestion) VALUES (?, ?)"
          (testId, titleQ)
    >>  toInteger
    <$> lastInsertRowId conn

addTest' :: T.Text -> IO Integer
addTest' titleT = withConnection dbName $ \conn ->
  execute conn "INSERT INTO tests(title) VALUES (?)" (Only titleT)
    >>  toInteger
    <$> lastInsertRowId conn

getTests :: IO [Test]
getTests = withConnection dbName $ \conn -> query_ conn "SELECT * FROM tests;"



