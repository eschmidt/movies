require 'rails_helper'

RSpec.describe 'Movies API', type: :request do
  # create some fake movie data
  let!(:movies) { create_list(:movie, 100) }
  let(:movie_id) { movies.first.movie_id }

  describe 'GET /movies' do
    before { get '/movies' }

    it 'returns the required fields' do
      expect(json.first).to match hash_including('imdb_id', 'title', 'genres', 'release_date', 'budget')
    end

    it 'does not return extra fields' do
      expect(json.first).to_not match hash_including('overview', 'production_companies', 'revenue', 'runtime', 'language', 'status')
    end

    it 'returns the default page size' do
      expect(json.size).to eq(50)
    end

    it 'returns 200' do
      expect(response).to have_http_status(200)
    end

    context 'when a year is specified' do
      before { get '/movies?year=2020' }

      let!(:movies) do
        create_list(:movie, 10, release_date: '2020-01-29')
        create_list(:movie, 10, release_date: '2019-01-29')
        create_list(:movie, 10, release_date: '2018-01-29')
      end

      it 'returns only movies released that year' do
        expect(json.size).to eq(10)
      end
    end
  end

  describe 'GET /movies/:movie_id' do
    before { get "/movies/#{movie_id}" }

    context 'when the movie exists' do
      it 'returns the movie info' do
        expect(json).to_not be_empty
      end

      it 'returns 200' do
        expect(response).to have_http_status(200)
      end
    end

    context 'when the movie does not exist' do
      let(:movie_id) { -42 }

      it 'returns 404' do
        expect(response).to have_http_status(404)
      end

      it 'returns a meaningful error message' do
        expect(response.body).to match(/Couldn't find Movie/)
      end
    end
  end

  def json
    JSON.parse(response.body)
  end
end
