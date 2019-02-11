# frozen_string_literal: true

require "sinatra"
require "rack-cache"

set :port, 1234
# curl -i http://localhost:1234
use Rack::Cache

get "/" do
  sleep 5

  cache_control :public, max_age: 10
  "la buum"
end
