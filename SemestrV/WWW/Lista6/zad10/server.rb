
# frozen_string_literal: true

require "sinatra"


set :port, 1234

get '/my_url/:param1' do
  response.set_cookie('test', {:value => 'test_data',:domain => "example.com", :path => '/'})
end

# curl -I localhost:1234/my_url/some_value