module TabloConnect
  class CopyController < ApplicationController
    before_action :set_item

    def index
      pid = spawn(ffmpeg_copy)
      Process.detach(pid)

      @item.copy_status = :in_progress
      @item.save

      render json: {pid: pid, destination: destination_path}, status: :ok
    end

    def status
      file_copy_status
      render json: {copy_status: @item.copy_status}
    end

    private

    def set_item
      model = case params[:type]
                when 'movie'
                  TabloConnect::Movie
                when 'show'
                  TabloConnect::Show
                else
                  return head :not_found if @item.nil?
              end

      @item = model.find_by_tablo_id(params[:tablo_id])
      head :not_found if @item.nil?
    end

    def source_path
      "#{TabloConnect.tablo_base_url}/pvr/#{@item.tablo_id}/pl/playlist.m3u8"
    end

    def destination_path
      "#{TabloConnect.output_directory}/#{file_name}"
    end

    def ffmpeg_copy
      "#{TabloConnect.ffmpeg_path} -i \"#{source_path}\" -bsf:a aac_adtstoasc -vcodec copy -c copy #{destination_path}"
    end

    def file_name
      if params[:type] == 'movie'
        "#{@item.title.gsub(/[^\w\.]/, ' ').squish.gsub(' ', '_')}.mp4"
      elsif params[:type] == 'show'
        "#{@item.show.gsub(/[^\w\.]/, ' ').squish.gsub(' ', '_')}.s#{@item.season.to_s.rjust(2, '0')}e#{@item.episode.to_s.rjust(2, '0')}_#{@item.tablo_id}.mp4"
      end
    end

    def file_copy_status
      update_copy_status(new_status) if new_status.to_s != @item.copy_status
    end

    def new_status
      return :idle unless File.exists?(destination_path)
      return :complete if file_unlocked?
      :in_progress
    end

    def update_copy_status(new_status)
      @item.copy_status = new_status
      @item.save
    end

    def file_unlocked?
      %x[lsof -F n].split("\n").grep(/#{destination_path}/).empty?
    end
  end
end
