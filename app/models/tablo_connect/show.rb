module TabloConnect
  class Show < ActiveRecord::Base
    validates_presence_of :tablo_ip, :tablo_id
    validates_uniqueness_of :tablo_ip, scope: :tablo_id

    enum copy_status: [:idle, :in_progress, :complete]

    scope :shows, -> { group(:show).order(:show).count }
    scope :show_episodes, ->(show) { where(show: show).order(:season, :episode, :rec_date, :title) }
    scope :find_by_tablo_ip, -> (tablo_ip) { where(tablo_ip: tablo_ip) }

    def self.shows_with_image_id
      self.shows.map { |show|
        image_data = self.select(:image_id, :tablo_ip).distinct(:image_id).where({show: show[0]}).order(image_id: :desc).limit(1).first
        {show: show[0], count: show[1], image_id: image_data.try(:[], :image_id), tablo_ip: image_data.try(:[], :tablo_ip)}
      }
    end

    def self.delete_by_tablo_id(delete_ids)
      self.where(tablo_id: delete_ids).delete_all
    end
  end
end
