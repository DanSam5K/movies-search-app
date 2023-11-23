#!/usr/bin/env ruby
require_relative '../lib/movies_client'

RSpec.describe MoviesClient do
  describe '.search' do
    context 'when the cache is invalid' do
      it 'fetches from the API' do
        allow(MoviesClient).to receive(:cache_valid?).and_return(false)
        allow(MoviesClient).to receive(:redis).and_return(double(get: '{}', set: nil))
        expect(MoviesClient).to receive(:fetch_from_api).and_return('{}')
        MoviesClient.search('Star Wars')
      end
    end
  end
end
