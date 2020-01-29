class CreateMovies < ActiveRecord::Migration[6.0]
  def change
    create_table :movies, primary_key: :movie_id do |t|
      t.string :imdb_id, null: false
      t.text :title, null: false
      t.text :overview
      t.text :production_companies
      t.date :release_date
      t.integer :budget
      t.integer :revenue
      t.float :runtime
      t.string :language
      t.text :genres
      t.string :status

      t.timestamps
    end
  end
end
