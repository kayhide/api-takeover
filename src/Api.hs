module Api where

import           ClassyPrelude

import           Data.Aeson                (ToJSON)
import           Data.Proxy                (Proxy (..))
import           Network.HTTP.Client       (Manager, defaultManagerSettings,
                                            newManager)
import           Network.HTTP.ReverseProxy (ProxyDest (..),
                                            WaiProxyResponse (..), defaultOnExc,
                                            waiProxyTo)
import           Network.Wai               (Application, Request)
import           Network.Wai.Handler.Warp  (run)
import           Servant                   ((:<|>) (..), (:>), Get, JSON, Raw,
                                            Server, Tagged (..), serve)


forwardRequest :: Request -> IO WaiProxyResponse
forwardRequest _ = pure $ WPRProxyDest $ ProxyDest "127.0.0.1" 5100

startApp :: IO ()
startApp = do
  manager <- newManager defaultManagerSettings
  run 8080 $ app manager



newtype Cat = Cat { cat :: String }
  deriving stock Generic
  deriving anyclass ToJSON

newtype Dog = Dog { dog :: String }
  deriving stock Generic
  deriving anyclass ToJSON


type API
  = "cat" :> Get '[JSON] Cat
  :<|> "dog" :> Get '[JSON] Dog

type API'
  = API :<|> Raw

appServer :: Server API
appServer = pure Cat { cat = "mrowl" }
  :<|> pure Dog { dog = "zzzzzzzzzzzz" }



proxyServer :: Manager -> Application
proxyServer = waiProxyTo forwardRequest defaultOnExc

server :: Manager -> Server API'
server manager = appServer :<|> Tagged (proxyServer manager)

app :: Manager -> Application
app manager = serve (Proxy @API') $ server manager
