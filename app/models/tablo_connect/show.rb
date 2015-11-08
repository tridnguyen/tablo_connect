module TabloConnect
  class Show < ActiveRecord::Base
    validates_presence_of :tablo_id
    validates_uniqueness_of :tablo_id

    enum copy_status: [:idle, :in_progress, :complete]

    scope :shows, -> { group(:show).order(:show).count }
    scope :show_episodes, ->(show) { where(show: show).order(:season, :episode, :rec_date, :title) }

    def self.shows_with_image_id
      self.shows.map { |show|
        image_id = self.select(:image_id).distinct(:image_id).where({show: show[0]}).order(image_id: :desc).limit(1)[0].try(:[], :image_id)

        {show: show[0], count: show[1], image_id: image_id}
      }
    end

    def self.delete_by_tablo_id(delete_ids)
      self.where(tablo_id: delete_ids).delete_all
    end
  end
end
