require 'open-uri'
require 'rest-client'

module TabloConnect
  class SyncController < ApplicationController
    def index
      begin
        TabloConnect.tablo_ips.each do |ip|
          item_ids = parse_items(ip)
          delete_removed(ip, item_ids)
          update_items(ip, item_ids)
        end

        head :ok
      rescue => e
        render json: {error: e.to_s}, status: :internal_server_error
      end
    end

    private

    def parse_items(tablo_ip)
      page = Nokogiri::HTML(open("#{TabloConnect.tablo_base_url(tablo_ip)}/pvr/"))
      page.css('tbody a').map { |row|
        row[:href].gsub('/', '').to_i if row[:href].gsub('/', '') =~ /\A\d+\z/
      }.compact
    end

    def delete_removed(tablo_ip, new_ids)
      old_ids = TabloConnect::Movie.find_by_tablo_ip(tablo_ip) + TabloConnect::Show.find_by_tablo_ip(tablo_ip)
      delete_ids = old_ids.map { |i| i.tablo_id } - new_ids

      TabloConnect::Movie.find_by_tablo_ip(tablo_ip).delete_by_tablo_id(delete_ids)
      TabloConnect::Show.find_by_tablo_ip(tablo_ip).delete_by_tablo_id(delete_ids)
    end

    def update_items(tablo_ip, tablo_ids)
      tablo_ids.each do |tablo_id|
        details = recording_details(tablo_ip, tablo_id)

        if details[:recMovie].present?
          update_movie(tablo_ip, tablo_id, details)
        elsif details[:recEpisode].present?
          update_show(tablo_ip, tablo_id, details)
        end
      end
    end

    def update_movie(tablo_ip, tablo_id, details)
      item = TabloConnect::Movie.find_or_create_by(tablo_ip: tablo_ip, tablo_id: tablo_id)
      item.title = details.try(:[], :recMovie).try(:[], :jsonForClient).try(:[], :title)
      item.description = details.try(:[], :recMovie).try(:[], :jsonForClient).try(:[], :plot)
      item.release_year = details.try(:[], :recMovie).try(:[], :jsonForClient).try(:[], :releaseYear)
      item.air_date = details.try(:[], :recMovieAiring).try(:[], :jsonForClient).try(:[], :airDate)
      item.image_id = details.try(:[], :recMovie).try(:[], :imageJson).try(:[], :images).try(:[], 0).try(:[], :imageID)
      item.save!
    end

    def update_show(tablo_ip, tablo_id, details)
      item = TabloConnect::Show.find_or_create_by(tablo_ip: tablo_ip, tablo_id: tablo_id)
      item.show = details.try(:[], :recEpisode).try(:[], :jsonFromTribune).try(:[], :program).try(:[], :title)
      item.title = details.try(:[], :recEpisode).try(:[], :jsonFromTribune).try(:[], :program).try(:[], :episodeTitle)
      item.description = details.try(:[], :recEpisode).try(:[], :jsonFromTribune).try(:[], :program).try(:[], :longDescription)
      item.episode = details.try(:[], :recEpisode).try(:[], :jsonFromTribune).try(:[], :program).try(:[], :episodeNum)
      item.season = details.try(:[], :recEpisode).try(:[], :jsonFromTribune).try(:[], :program).try(:[], :seasonNum)
      item.rec_date = details.try(:[], :recEpisode).try(:[], :jsonForClient).try(:[], :airDate)
      item.air_date = details.try(:[], :recEpisode).try(:[], :jsonForClient).try(:[], :originalAirDate)
      item.image_id = details.try(:[], :recSeries).try(:[], :imageJson).try(:[], :images).try(:[], 0).try(:[], :imageID)
      item.save!
    end

    def recording_details(tablo_ip, tablo_id)
      JSON.parse(RestClient.get("#{TabloConnect.tablo_base_url(tablo_ip)}/pvr/#{tablo_id}/meta.txt")).with_indifferent_access
    end
  end
end
