{-# LANGUAGE DataKinds       #-}
{-# LANGUAGE TypeOperators   #-}
{-# LANGUAGE OverloadedStrings #-}

module Api where

import           Control.Monad.IO.Class
import           Database
import           Network.Wai
import           Network.Wai.Handler.Warp
import           Servant
import           Network.Wai.Middleware.Cors


import           Types


type API = "tests" :> Get '[JSON] [Test]
      :<|> "tests" :> ReqBody '[JSON] TestInput :> Post '[JSON] TestInput

server :: Server API
server = pure testTests
    :<|> \ti -> liftIO (addTest ti) >> pure ti


app :: Application
app = middleware $ serve (Proxy :: Proxy API) server

middleware :: Middleware
middleware = cors (const $ Just simpleCorsResourcePolicy 
  {corsRequestHeaders = ["Content-Type"]}) 

startApp :: IO ()
startApp = run 8080 app
