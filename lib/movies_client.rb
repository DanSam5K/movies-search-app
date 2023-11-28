#!/usr/bin/env ruby
require 'httparty'
require 'redis'

class MoviesClient
  BASE_URL = 'https://api.themoviedb.org/3/search/movie'.freeze
  API_KEY = ''.freeze # substitute with your API key actual API key here
  def self.redis
    @redis ||= Redis.new
  end

  def self.search(movie_name)
    if cache_valid?(movie_name)
      increment_hits(movie_name)
      get_cached_response(movie_name)
    else
      fetch_and_cache(movie_name)
    end
  rescue Redis::BaseError => e
    puts "Redis error: #{e.message}"
  end

  def self.fetch_from_api(movie_name)
    response = HTTParty.get(BASE_URL, query: { api_key: API_KEY, query: movie_name })
    response.parsed_response if response.code == 200
  rescue HTTParty::Error => e
    puts "HTTParty error: #{e.message}"
  end

  def self.cache_response(movie_name, response)
    redis.set(movie_name, response.to_json)
    redis.set("#{movie_name}_timestamp", Time.now.to_i)
    redis.set("#{movie_name}_hits", 0)
  end

  def self.cache_valid?(movie_name)
    timestamp = redis.get("#{movie_name}_timestamp").to_i
    (Time.now.to_i - timestamp) < 120
  rescue Redis::BaseError => e
    puts "Redis error: #{e.message}"
  end

  def self.increment_hits(movie_name)
    redis.incr("#{movie_name}_hits")
  rescue Redis::BaseError => e
    puts "Redis error: #{e.message}"
  end

  def self.get_cached_hits(movie_name)
    redis.get("#{movie_name}_hits")
  rescue Redis::BaseError => e
    puts "Redis error: #{e.message}"
  end

  def self.get_cached_response(movie_name)
    JSON.parse(redis.get(movie_name))
  rescue Redis::BaseError => e
    puts "Redis error: #{e.message}"
  end

  def self.fetch_and_cache(movie_name)
    response = fetch_from_api(movie_name)
    cache_response(movie_name, response) if response
    response
  end
end
