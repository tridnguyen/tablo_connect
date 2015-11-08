class CreateTabloConnectMovies < ActiveRecord::Migration
  def change
    create_table :tablo_connect_movies do |t|
      t.integer :tablo_id
      t.string :title
      t.text :description
      t.integer :release_year
      t.datetime :air_date
      t.integer :image_id
      t.integer :copy_status, default: 0

      t.timestamps null: false
    end

    add_index :tablo_connect_movies, :tablo_id, :unique => true
    add_index :tablo_connect_movies, :title
  end
end
