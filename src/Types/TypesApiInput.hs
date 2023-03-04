{-# LANGUAGE DeriveGeneric #-}
module Types.TypesApiInput where

import           Data.Aeson
import qualified Data.Text                     as T
import           GHC.Generics

data Test = Test
  { title     :: T.Text
  , questions :: [Question]
  }
  deriving Generic
instance ToJSON Test where
instance FromJSON Test where

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
