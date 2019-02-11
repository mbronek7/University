# frozen_string_literal: true

require "sinatra"

get "/new" do
  erb :new
end

post "/new" do
  "#{params[:content]}"
end
