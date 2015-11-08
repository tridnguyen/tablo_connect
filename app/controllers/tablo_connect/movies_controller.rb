module TabloConnect
  class MoviesController < ApplicationController
    def index
      movies = Movie.all_order_title

      render json: {movies: movies}
    end
  end
end
