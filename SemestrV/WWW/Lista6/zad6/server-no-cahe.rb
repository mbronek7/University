# frozen_string_literal: true

require "sinatra"

set :port, 1234
# curl -i http://localhost:1234

get "/" do
  "buum!"
end
