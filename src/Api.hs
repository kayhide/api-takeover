module Api where

import           ClassyPrelude

import           Data.Aeson                (ToJSON, object, toJSON, (.=))
import           Data.Proxy                (Proxy (..))
import           Network.HTTP.Client       (Manager, defaultManagerSettings,
                                            newManager)
import           Network.HTTP.ReverseProxy (ProxyDest (..),
                                            WaiProxyResponse (..), defaultOnExc,
                                            waiProxyTo)
import           Network.Wai               (Application, Request)
import           Network.Wai.Handler.Warp  (run)
import           Servant                   ((:<|>) (..), (:>), Get, JSON, Proxy,
                                            Raw, Server, serve, Tagged (..))


forwardRequest :: Request -> IO WaiProxyResponse
forwardRequest _ = pure $ WPRProxyDest $ ProxyDest "127.0.0.1" 5100

startApp :: IO ()
startApp = do
  manager <- newManager defaultManagerSettings
  run 8080 $ app manager



newtype Cat = Cat { cat :: String }
  deriving Generic
  deriving anyclass ToJSON


type CatAPI
  = "cat" :> Get '[JSON] Cat

type API
  = CatAPI :<|> Raw

catServer :: Server CatAPI
catServer = pure Cat { cat = "mrowl" }

proxyServer :: Manager -> Application
proxyServer = waiProxyTo forwardRequest defaultOnExc

server :: Manager -> Server API
server manager = catServer :<|> Tagged (proxyServer manager)

api :: Proxy API
api = Proxy

app :: Manager -> Application
app manager = serve api $ server manager
