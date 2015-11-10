class AddTabloIpToTabloConnectMovies < ActiveRecord::Migration
  def change
    add_column :tablo_connect_movies, :tablo_ip, :string
    remove_index :tablo_connect_movies, :tablo_id
    add_index :tablo_connect_movies, [:tablo_ip, :tablo_id], :unique => true
  end
end
