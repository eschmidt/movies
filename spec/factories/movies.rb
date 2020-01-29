FactoryBot.define do
  factory :movie do
    movie_id { Faker::Number.number(digits: 10) }
    imdb_id { Faker::Alphanumeric.alphanumeric(number: 10) }
    title { Faker::ChuckNorris.fact }
    genres { '[{"id": 18, "name": "Drama"}, {"id": 80, "name": "Crime"}]' }
    release_date { Faker::Date.backward(days: 60) }
    budget { Faker::Number.between(from: 1_000_000, to: 100_000_000) }
  end
end
