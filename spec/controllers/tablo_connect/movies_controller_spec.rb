require 'spec_helper'

module TabloConnect
  describe MoviesController, type: :controller do
    routes { TabloConnect::Engine.routes }

    describe "GET index" do
      let!(:movie) { FactoryGirl.create(:tablo_connect_movie) }

      it "returns a 200" do
        get :index
        expect(response.status).to eq 200
      end

      it "returns an object with a movies array" do
        get :index
        json_body = JSON.parse(response.body).with_indifferent_access
        expect(json_body[:movies].count).to eq 1
      end

      it "calls Movie.all_order_title" do
        expect(Movie).to receive(:all_order_title)
        get :index
      end
    end
  end
end