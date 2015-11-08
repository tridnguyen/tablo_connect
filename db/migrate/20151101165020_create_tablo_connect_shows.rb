class CreateTabloConnectShows < ActiveRecord::Migration
  def change
    create_table :tablo_connect_shows do |t|
      t.integer :tablo_id
      t.string :show
      t.string :title
      t.text :description
      t.integer :episode
      t.integer :season
      t.date :air_date
      t.datetime :rec_date
      t.integer :image_id
      t.integer :copy_status, default: 0

      t.timestamps null: false
    end

    add_index :tablo_connect_shows, :tablo_id, :unique => true
    add_index :tablo_connect_shows, :show
  end
end
