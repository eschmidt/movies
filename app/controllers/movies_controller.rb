require 'rest-client'

class MoviesController < ApplicationController
  # GET /movies
  def index
    movies = Movie.select(:imdb_id, :title, :genres, :release_date, :budget)

    # filter by year if "?year=xxxx" given
    movies.where("release_date >= ? and release_date <= ?", "#{permitted_params[:year]}-01-01", "#{permitted_params[:year]}-12-31") if permitted_params[:year]
    #movies.where("release_date like ?", "#{permitted_params[:year]}\-%") if permitted_params[:year]

    # filter by genre if "?genre=x" given
    movies.where("genres like ?", "%\"#{permitted_params[:genre]}\"%") if permitted_params[:genre]

    # sort by release date
    order_field = 'release_date'
    order_field << " DESC" if permitted_params[:sort]&.casecmp? "desc"
    movies.order(order_field)

    json_response(movies.paginate(page: permitted_params[:page], per_page: 50))
  end

  # GET /movies/:movie_id
  def show
    # find movie
    movie = Movie.select(:imdb_id, :title, :description, :release_date, :budget, :runtime, :genres, :language, :production_companies).find(permitted_params[:movie_id]).as_json

    # find average rating from separate ratings microservice
    movie[:average_rating] = nil  # nil by default

    begin
      rating_response = RestClient.get "http://localhost:3001/ratings/average/#{permitted_params[:movie_id]}"
      movie[:average_rating] = JSON.parse(rating_response.body)['average_rating']
    rescue Errno::ECONNREFUSED, RestClient::ExceptionWithResponse => e
      # ignore errors for now, just keep the nil default for this field
    end

    # return a hash containing both movie fields and average rating
    json_response(movie)
  end

  private

  def permitted_params
    params.permit(:movie_id, :year, :genre, :page, :sort)
  end
end
