#!/usr/bin/env ruby
require 'sinatra'
require 'json'
require_relative 'lib/movies_client'

get '/' do
  send_file File.join(settings.public_folder, 'index.html')
end

post '/search' do
  content_type :json
  movie_name = params[:movie_name]

  {results: "Hello #{movie_name}"}
end
