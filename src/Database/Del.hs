{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ScopedTypeVariables #-}
module Database.Del where

import           Database.SQLite.Simple

import           Const


removeTestById :: Integer -> IO ()
removeTestById idT = withConnection dbName $ \conn -> do
  removeQuestionsByTestId idT
  execute conn "DELETE FROM tests WHERE id = ?;" (Only idT)

removeQuestionsByTestId :: Integer -> IO ()
removeQuestionsByTestId idT = withConnection dbName $ \conn -> do
  -- получили id вопросов
  (qsIds :: [Only Integer]) <- query
    conn
    "SELECT id FROM questions WHERE test_id = ?;"
    (Only idT)
  mapM_ (removeAnswersByQuestionId . fromOnly) qsIds
  -- удалить вопросы
  execute conn "DELETE FROM questions WHERE test_id = ?;" (Only idT)

removeAnswersByQuestionId :: Integer -> IO ()
removeAnswersByQuestionId idQ = withConnection dbName $ \conn ->
  execute conn "DELETE FROM answers WHERE question_id = ?;" (Only idQ)
