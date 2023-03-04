{-# LANGUAGE DeriveGeneric #-}
module Types.Types where

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

