require 'spec_helper'

module TabloConnect
  describe ShowsController, type: :controller do
    routes { TabloConnect::Engine.routes }

    let!(:show) { FactoryGirl.create(:tablo_connect_show, show: 'Angle of Attack') }

    describe "GET index" do
      it "returns a 200" do
        get :index
        expect(response.status).to eq 200
      end

      it "returns an object with a shows array" do
        get :index
        json_body = JSON.parse(response.body).with_indifferent_access
        expect(json_body[:shows].size).to eq 1
      end

      it "calls Shows.shows_with_image_id" do
        expect(Show).to receive(:shows_with_image_id)
        get :index
      end
    end

    describe "GET episodes" do
      it "returns a 200" do
        get :episodes, {show: 'Angle of Attack'}
        expect(response.status).to eq 200
      end

      it "returns an object with an episodes array" do
        get :episodes, {show: 'Angle of Attack'}
        json_body = JSON.parse(response.body).with_indifferent_access
        expect(json_body[:episodes].size).to eq 1
      end

      it "calls Shows.show_episodes" do
        expect(Show).to receive(:show_episodes).with('Angle of Attack')
        get :episodes, {show: 'Angle of Attack'}
      end
    end
  end
end