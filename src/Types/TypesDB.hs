{-# LANGUAGE DeriveGeneric #-}
module Types.TypesDB where

import qualified Data.Text                     as T
import           Database.SQLite.Simple
import           GHC.Generics

data Question = Question
  { testId       :: Integer
  , questionId   :: Integer
  , textQuestion :: T.Text
  }
  deriving (Show, Generic)
instance FromRow Question where

data Answer = Answer
  { questionIdA :: Integer
  , idAnswer    :: Integer
  , textAnswer  :: T.Text
  , isCorrect   :: Bool
  }
  deriving (Show, Generic)
instance FromRow Answer where
