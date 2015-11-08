require 'spec_helper'

module TabloConnect
  describe Movie do
    describe "validates presence of tablod_id" do
      it { is_expected.to validate_presence_of(:tablo_id) }
    end

    describe "validates uniqueness of tablod_id" do
      it { is_expected.to validate_uniqueness_of(:tablo_id) }
    end

    describe ".all_order_title" do
      let!(:movie1) { FactoryGirl.create(:tablo_connect_movie, title: 'B starts the title') }
      let!(:movie2) { FactoryGirl.create(:tablo_connect_movie, title: 'A starts the title') }

      it "orders the movies by title" do
        movies =TabloConnect::Movie.all_order_title
        expect(movies[0].title).to eq movie2.title
        expect(movies[1].title).to eq movie1.title
      end
    end

    describe ".delete_by_tablo_id" do
      let!(:movie1) { FactoryGirl.create(:tablo_connect_movie, title: 'B starts the title') }

      it "deletes all for tablo_id provided" do
        expect{TabloConnect::Movie.delete_by_tablo_id movie1.tablo_id}.to change{TabloConnect::Movie.count}.by -1
      end
    end
  end
end
