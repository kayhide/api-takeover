require "sinatra"
require "json"

get "/" do
  <<EOS
  You can get either <a href="cat">cat</a> or <a href="dog">dog</a>.
EOS
end


get "/cat" do
  { cat: "meow" }.to_json
end

get "/dog" do
  { dog: "woof" }.to_json
end
