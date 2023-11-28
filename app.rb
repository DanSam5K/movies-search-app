#!/usr/bin/env ruby
require 'sinatra'
require 'sinatra/cors'
require 'json'
require_relative 'lib/movies_client'

set :allow_origin, '*'
set :allow_methods, 'GET,HEAD,POST'
set :allow_headers, 'content-type,if-modified-since'
set :expose_headers, 'location,link'

get '/' do
  send_file File.join(settings.public_folder, 'index.html')
end

post '/search' do
  content_type :json
  request_payload = JSON.parse(request.body.read)
  movie_name = request_payload['query']

  search_result = MoviesClient.search(movie_name)
  { movie: search_result }.to_json
end
