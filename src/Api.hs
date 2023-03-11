{-# LANGUAGE DataKinds       #-}
{-# LANGUAGE TypeOperators   #-}
{-# LANGUAGE OverloadedStrings #-}

module Api where

import           Control.Monad.IO.Class
import           Network.Wai
import           Network.Wai.Handler.Warp
import           Servant
import           Network.Wai.Middleware.Cors

import           Types.Types
import qualified Types.TypesApiInput           as TI
import qualified Types.TypesApiOutput          as TO
import           Database.Get
import           Database.Add
import           Database.Del

type API = "tests" :> Get '[JSON] [Test]
      :<|> "tests" :> ReqBody '[JSON] TI.Test :> Post '[JSON] TI.Test 
      :<|> "tests" :> Capture "test_id" Integer :> Get '[JSON] TO.Test
      -- удалить тест
      :<|> "tests" :> Capture "test_id" Integer :> Delete '[JSON] Bool
      -- редактировать тест
      :<|> "tests" :> Capture "test_id" Integer :> ReqBody '[JSON] TI.Test  
                   :> Put '[JSON] Bool
      -- проверка ответа
      :<|> "answer" :> Capture "answer_id" Integer :> Get '[JSON] Bool



server :: Server API
server = liftIO getTests
    :<|> (\ti ->  liftIO (addTest ti) >> pure ti)
    :<|> (liftIO . getTest)
    -- удалить тест
    :<|> (\i ->  liftIO (removeTestById i >> pure True))
    -- редактировать тест
    :<|> (\i ti -> liftIO (removeTestById i >> addTest ti) >> pure True)
    -- проверка ответа
    :<|> (liftIO . checkCorrectAnswer)
    


app :: Application
app = middleware $ serve (Proxy :: Proxy API) server

middleware :: Middleware
middleware = cors (const $ Just simpleCorsResourcePolicy 
   { corsRequestHeaders = ["Content-Type"]
   , corsMethods = ["GET", "POST", "PUT", "OPTIONS", "DELETE"]
   }) 

startApp :: IO ()
startApp = run 8080 app
