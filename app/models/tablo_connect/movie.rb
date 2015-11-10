module TabloConnect
  class Movie < ActiveRecord::Base
    validates_presence_of :tablo_ip, :tablo_id
    validates_uniqueness_of :tablo_ip, scope: :tablo_id

    enum copy_status: [:idle, :in_progress, :complete]

    scope :all_order_title, -> { self.all.order(:title) }
    scope :find_by_tablo_ip, -> (tablo_ip) { where(tablo_ip: tablo_ip) }

    def self.delete_by_tablo_id(delete_ids)
      self.where(tablo_id: delete_ids).delete_all
    end
  end
end