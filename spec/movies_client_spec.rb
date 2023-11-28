#!/usr/bin/env ruby
require_relative '../lib/movies_client'

RSpec.describe MoviesClient do
  describe '.search' do
    let(:movie_name) { 'Inception' }

    context 'when the cache is invalid' do
      it 'fetches from the API' do
        allow(MoviesClient).to receive(:cache_valid?).and_return(false)
        allow(MoviesClient).to receive(:redis).and_return(double(get: '{}', set: nil))
        expect(MoviesClient).to receive(:fetch_from_api).and_return('{}')
        MoviesClient.search('Star Wars')
      end
    end

    context 'when the cache is valid' do
      before do
        allow(MoviesClient).to receive(:cache_valid?).with(movie_name).and_return(true)
        allow(MoviesClient).to receive(:get_cached_response).with(movie_name)
          .and_return({ 'title' => 'Inception' }.to_json)
      end

      it 'returns the cached response' do
        expect(MoviesClient.search(movie_name)).to eq({ 'title' => 'Inception' }.to_json)
      end
    end

    context 'when the cache is not valid' do
      before do
        allow(MoviesClient).to receive(:cache_valid?).with(movie_name).and_return(false)
        allow(MoviesClient).to receive(:fetch_and_cache).with(movie_name)
          .and_return({ 'title' => 'Inception' }.to_json)
      end

      it 'fetches from the API and caches the response' do
        expect(MoviesClient.search(movie_name)).to eq({ 'title' => 'Inception' }.to_json)
      end
    end
  end
end
