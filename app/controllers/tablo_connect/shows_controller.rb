module TabloConnect
  class ShowsController < ApplicationController
    def index
      render json: {shows: Show.shows_with_image_id}
    end

    def episodes
      render json: {episodes: Show.show_episodes(params.require(:show))}
    end
  end
end
