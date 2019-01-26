module Api where

import           ClassyPrelude

import           Network.HTTP.Client       (Manager, defaultManagerSettings,
                                            newManager)
import           Network.HTTP.ReverseProxy (ProxyDest (..),
                                            WaiProxyResponse (..), defaultOnExc,
                                            waiProxyTo)
import           Network.Wai               (Application, Request)
import           Network.Wai.Handler.Warp  (run)


forwardRequest :: Request -> IO WaiProxyResponse
forwardRequest _ = pure $ WPRProxyDest $ ProxyDest "127.0.0.1" 5100

app :: Manager -> Application
app manager =
  waiProxyTo forwardRequest defaultOnExc manager

startApp :: IO ()
startApp = do
  manager <- newManager defaultManagerSettings
  run 8080 $ app manager
