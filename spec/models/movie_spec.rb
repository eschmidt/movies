require 'rails_helper'

RSpec.describe Movie, type: :model do
  it { should validate_presence_of(:movie_id) }
  it { should validate_presence_of(:imdb_id) }
  it { should validate_presence_of(:title) }
end
