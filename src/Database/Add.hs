{-# LANGUAGE OverloadedStrings #-}
module Database.Add where

import qualified Data.Text                     as T
import           Database.SQLite.Simple

import           Const
import qualified Types.TypesApiInput           as TI

addTest :: TI.Test -> IO ()
addTest (TI.Test titleTI questions) = do
  idTest <- addTest' titleTI
  mapM_ (addQuestion idTest) questions

addQuestion :: Integer -> TI.Question -> IO ()
addQuestion idTest (TI.Question titleQ answers) = do
  idQuestion <- addQuestion' idTest titleQ
  mapM_ (addAnswer idQuestion) answers

addAnswer :: Integer -> TI.Answer -> IO ()
addAnswer idQuestion (TI.Answer textA isC) = withConnection dbName $ \conn ->
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
