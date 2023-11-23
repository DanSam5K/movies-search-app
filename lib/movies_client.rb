#!/usr/bin/env ruby
require 'httparty'
require 'redis'

class MoviesClient
  BASE_URL = 'https://api.themoviedb.org/3/search/movie'.freeze
  API_KEY = ENV.fetch('MOVIES_API_KEY', nil) # replace with your API key actual API key here
  def self.redis
    @redis ||= Redis.new
  end

  def self.search(movie_name)
    if cache_valid?(movie_name)
      redis.incr("#{movie_name}_hits")
      JSON.parse(redis.get(movie_name))
    else
      response = fetch_from_api(movie_name)
      cache_response(movie_name, response)
      response
    end
  end

  def self.fetch_from_api(movie_name)
    HTTParty.get(BASE_URL, query: { api_key: API_KEY, query: movie_name })
  end

  def self.cache_response(movie_name, response)
    redis.set(movie_name, response.to_json)
    redis.set("#{movie_name}_timestamp", Time.now.to_i)
    redis.set("#{movie_name}_hits", 0)
  end

  def self.cache_valid?(movie_name)
    timestamp = redis.get("#{movie_name}_timestamp").to_i
    (Time.now.to_i - timestamp) < 120
  end
end
