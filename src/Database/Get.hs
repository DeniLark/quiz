{-# LANGUAGE OverloadedStrings #-}
module Database.Get where

import           Database.SQLite.Simple

import           Const
import           Types.Types
import qualified Types.TypesApiInput           as TI
import qualified Types.TypesDB                 as DBT

getTests :: IO [Test]
getTests = withConnection dbName
  $ \conn -> query_ conn "SELECT * FROM tests ORDER BY id DESC;"

getTest :: Integer -> IO TI.Test
getTest idTest = withConnection dbName $ \conn -> do
  (Test _ titleTest) <- head
    <$> query conn "SELECT * FROM tests WHERE id = ?;" (Only idTest)
  qs <- getQuestions idTest >>= mapM dbQuestionToQuestion
  pure $ TI.Test titleTest qs

getQuestions :: Integer -> IO [DBT.Question]
getQuestions idTest = withConnection dbName $ \conn ->
  query conn "SELECT * FROM questions WHERE test_id = ?;" (Only idTest)

getAnswers :: Integer -> IO [DBT.Answer]
getAnswers idQuestion = withConnection dbName $ \conn ->
  query conn "SELECT * FROM answers WHERE question_id = ?;" (Only idQuestion)

dbQuestionToQuestion :: DBT.Question -> IO TI.Question
dbQuestionToQuestion (DBT.Question _ idQ textQ) = do
  as <- getAnswers idQ
  pure $ TI.Question textQ $ map
    (TI.Answer <$> DBT.textAnswer <*> DBT.isCorrect)
    as
