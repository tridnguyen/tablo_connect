require 'spec_helper'

module TabloConnect
  describe Show do
    describe "validates presence of tablod_id" do
      it { is_expected.to validate_presence_of(:tablo_id) }
    end

    describe "validates uniqueness of tablod_id" do
      it { is_expected.to validate_uniqueness_of(:tablo_id) }
    end

    describe ".shows" do
      let!(:show) { FactoryGirl.create(:tablo_connect_show) }

      it "returns the show name" do
        expect(TabloConnect::Show.shows.first[0]).to eq show.show
      end

      it "returns the show count" do
        expect(TabloConnect::Show.shows.first[1]).to be 1
      end
    end

    describe ".show_episodes" do
      let!(:show1) { FactoryGirl.create(:tablo_connect_show, show: "Alf") }
      let!(:show2) { FactoryGirl.create(:tablo_connect_show, show: "Alf") }
      let!(:show3) { FactoryGirl.create(:tablo_connect_show) }

      it "returns all shows matching the show parameter" do
        expect(TabloConnect::Show.show_episodes(show1.show).count).to be 2
      end
    end

    describe ".shows_with_image_id" do
      let!(:show1) { FactoryGirl.create(:tablo_connect_show, show: "Charles in Charge") }
      let!(:show2) { FactoryGirl.create(:tablo_connect_show, show: "Mr. Belvedere") }
      let!(:show3) { FactoryGirl.create(:tablo_connect_show, show: "Robotech") }

      it "returns an array of shows" do
        expect(TabloConnect::Show.shows_with_image_id.count).to be 3
      end

      it "returns an array of objects with the show name" do
        expect(TabloConnect::Show.shows_with_image_id.first[:show]).to eq 'Charles in Charge'
      end

      it "returns an array of objects with the show count" do
        expect(TabloConnect::Show.shows_with_image_id.first[:count]).to be 1
      end

      it "returns an array of objects with the image_id" do
        expect(TabloConnect::Show.shows_with_image_id.first[:image_id]).to eq show1.image_id
      end
    end

    describe ".delete_by_tablo_id" do
      let!(:show_to_delete) { FactoryGirl.create(:tablo_connect_show) }

      it "deletes all for tablo_id provided" do
        expect{TabloConnect::Show.delete_by_tablo_id show_to_delete.tablo_id}.to change{TabloConnect::Show.count}.by -1
      end
    end
  end
end
