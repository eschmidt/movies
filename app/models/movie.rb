class Movie < ApplicationRecord
  self.primary_key = :movie_id

  validates_presence_of :movie_id
  validates_presence_of :imdb_id
  validates_presence_of :title
end
