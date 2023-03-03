{-# LANGUAGE DeriveGeneric #-}
module Types where

import           Data.Aeson
import qualified Data.Text                     as T
import           Database.SQLite.Simple
import           GHC.Generics


data Test = Test
  { testId    :: Integer
  , testTitle :: T.Text
  }
  deriving Generic

instance ToJSON Test where
instance FromJSON Test where
instance FromRow Test where

data TestInput = TestInput
  { title     :: T.Text
  , questions :: [Question]
  }
  deriving Generic
instance ToJSON TestInput where
instance FromJSON TestInput where

data Question = Question
  { textQuestion :: T.Text
  , answers      :: [Answer]
  }
  deriving Generic
instance ToJSON Question where
instance FromJSON Question where

data Answer = Answer
  { textAnswer :: T.Text
  , isCorrect  :: Bool
  }
  deriving Generic
instance ToJSON Answer where
instance FromJSON Answer where
