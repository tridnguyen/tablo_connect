require 'spec_helper'

module TabloConnect
  describe SyncController, type: :controller do
    routes { TabloConnect::Engine.routes }

    describe "GET index" do
      before do
        allow(controller).to receive(:parse_items).and_return([12345, 6789])
        allow(controller).to receive(:delete_removed)
        allow(controller).to receive(:update_items)
      end

      it "returns a 200" do
        get :index
        expect(response.status).to eq 200
      end

      it "calls parse_item" do
        expect(controller).to receive(:parse_items)
        get :index
      end

      it "calls delete_removed" do
        expect(controller).to receive(:delete_removed).with(TabloConnect.tablo_ips[0], [12345, 6789])
        get :index
      end

      it "calls update_items" do
        expect(controller).to receive(:update_items).with(TabloConnect.tablo_ips[0], [12345, 6789])
        get :index
      end
    end

    describe ".parse_items" do
      it "returns an array of tablo_ids by parsing the html document" do
        allow(controller).to receive(:open).and_return('<?xml version="1.0" encoding="iso-8859-1"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
<head>
<title>Index of /pvr/</title>
</head>
<body>
<h2>Index of /pvr/</h2>
<div class="list">
<table summary="Directory Listing" cellpadding="0" cellspacing="0">
<thead><tr><th class="n">Name</th><th class="m">Last Modified</th><th class="s">Size</th><th class="t">Type</th></tr></thead>
<tbody>
<tr><td class="n"><a href="../">Parent Directory</a>/</td><td class="m">&nbsp;</td><td class="s">- &nbsp;</td><td class="t">Directory</td></tr>
<tr><td class="n"><a href="114610/">114610</a>/</td><td class="m">2015-Apr-30 16:35:44</td><td class="s">- &nbsp;</td><td class="t">Directory</td></tr>
<tr><td class="n"><a href="114612/">114612</a>/</td><td class="m">2015-Apr-30 17:05:48</td><td class="s">- &nbsp;</td><td class="t">Directory</td></tr>
</tbody>
</table>
</body>
</html>')
        expect(controller.send(:parse_items, TabloConnect.tablo_ips[0])).to match([114610, 114612])
      end
    end

    describe ".delete_removed" do
      let!(:movie) { FactoryGirl.create(:tablo_connect_movie) }
      let!(:show) { FactoryGirl.create(:tablo_connect_show) }

      it "deletes ids in TabloConnect::Movie that are not in the array sent" do
        delta = [movie.tablo_id, show.tablo_id] - [1, 2, 3, 4, 5, 6]
        expect(TabloConnect::Movie).to receive(:delete_by_tablo_id).with(delta)
        controller.send(:delete_removed, TabloConnect.tablo_ips[0], [1, 2, 3, 4, 5, 6])
      end

      it "deletes ids in TabloConnect::Show that are not in the array sent" do
        delta = [movie.tablo_id, show.tablo_id] - [1, 2, 3, 4, 5, 6]
        expect(TabloConnect::Show).to receive(:delete_by_tablo_id).with(delta)
        controller.send(:delete_removed, TabloConnect.tablo_ips[0], [1, 2, 3, 4, 5, 6])
      end
    end

    describe ".update_items" do
      context "when the item is a movie" do
        it "calls update_movie" do
          allow(controller).to receive(:recording_details).and_return({recMovie: 1})
          expect(controller).to receive(:update_movie).twice
          controller.send(:update_items, TabloConnect.tablo_ips[0], [1, 2])
        end
      end

      context "when the item is a show" do
        it "calls update_show" do
          allow(controller).to receive(:recording_details).and_return({recEpisode: 1})
          expect(controller).to receive(:update_show).twice
          controller.send(:update_items, TabloConnect.tablo_ips[0], [1, 2])
        end
      end
    end

    describe ".update_movie" do
      let(:details) { {:recMovieAiring => {:jsonForClient => {:airDate => "2015-10-18T19:30Z"}, :jsonFromTribune => {:program => {:title => "Thomas & Friends: Sodor's Legend of the Lost Treasure", :releaseYear => 2015, :shortDescription => "Thomas races against Sailor John (John Hurt) to find treasure from an old pirate ship.", :longDescription => "Thomas races against Sailor John (John Hurt) to find treasure from an old pirate ship."}}}, :recMovie => {:jsonForClient => {:plot => "Thomas races against Sailor John (John Hurt) to find treasure from an old pirate ship.", :releaseYear => 2015, :title => "Thomas & Friends: Sodor's Legend of the Lost Treasure"}, :imageJson => {:images => [{:type => "image", :imageID => 372899, :imageType => "movie_2x3_small", :imageStyle => "thumbnail"}]}}} }

      context "when the item is not found" do
        it "creates the item" do
          expect { controller.send(:update_movie, TabloConnect.tablo_ips[0], 1234, details) }.to change { TabloConnect::Movie.count }.by(1)
        end
      end

      context "when the item is found" do
        let!(:movie) { FactoryGirl.create(:tablo_connect_movie) }

        it "updates the record instead of creating a new one" do
          expect { controller.send(:update_movie,TabloConnect.tablo_ips[0],  movie.tablo_id, details) }.to_not change { TabloConnect::Movie.count }
        end

        it "updates the title" do
          controller.send(:update_movie,TabloConnect.tablo_ips[0],  movie.tablo_id, details)
          movie.reload
          expect(movie.title).to eq details[:recMovie][:jsonForClient][:title]
        end

        it "updates the description" do
          controller.send(:update_movie, TabloConnect.tablo_ips[0], movie.tablo_id, details)
          movie.reload
          expect(movie.description).to eq details[:recMovie][:jsonForClient][:plot]
        end

        it "updates the release year" do
          controller.send(:update_movie, TabloConnect.tablo_ips[0], movie.tablo_id, details)
          movie.reload
          expect(movie.release_year).to eq details[:recMovie][:jsonForClient][:releaseYear]
        end

        it "updates the air_date" do
          controller.send(:update_movie, TabloConnect.tablo_ips[0], movie.tablo_id, details)
          movie.reload
          expect(movie.air_date).to eq details[:recMovieAiring][:jsonForClient][:airDate]
        end

        it "updates the image_id" do
          controller.send(:update_movie, TabloConnect.tablo_ips[0], movie.tablo_id, details)
          movie.reload
          expect(movie.image_id).to eq details[:recMovie][:imageJson][:images][0][:imageID]
        end
      end
    end

    describe ".update_show" do
      let(:details) { {:recEpisode => {:jsonFromTribune => {:program => {:episodeNum => 63, :episodeTitle => "The Story of Mother Goose", :longDescription => "Mother Goose helps Red write a new song.", :origAirDate => "2010-07-12", :releaseDate => "2010-09-25", :releaseYear => 2010, :seasonNum => 1, :title => "Super Why!"}},:jsonForClient => {:originalAirDate => "2000-10-01", :airDate => "2015-10-18T19:30Z"}}, :recSeries => {:jsonForClient => {:originalAirDate => "2007-09-03"}, :imageJson => {:images => [{:type => "image", :imageID => 177446, :imageType => "series_3x4_small", :imageStyle => "thumbnail"}]}}} }

      context "when the item is not found" do
        it "creates the item" do
          expect { controller.send(:update_show, TabloConnect.tablo_ips[0], 1234, details) }.to change { TabloConnect::Show.count }.by(1)
        end
      end

      context "when the item is found" do
        let!(:show) { FactoryGirl.create(:tablo_connect_show) }

        it "updates the record instead of creating a new one" do
          expect { controller.send(:update_show, TabloConnect.tablo_ips[0], show.tablo_id, details) }.to_not change { TabloConnect::Show.count }
        end

        it "updates the show" do
          controller.send(:update_show, TabloConnect.tablo_ips[0], show.tablo_id, details)
          show.reload
          expect(show.show).to eq details[:recEpisode][:jsonFromTribune][:program][:title]
        end

        it "updates the title" do
          controller.send(:update_show, TabloConnect.tablo_ips[0], show.tablo_id, details)
          show.reload
          expect(show.title).to eq details[:recEpisode][:jsonFromTribune][:program][:episodeTitle]
        end

        it "updates the description" do
          controller.send(:update_show, TabloConnect.tablo_ips[0], show.tablo_id, details)
          show.reload
          expect(show.description).to eq details[:recEpisode][:jsonFromTribune][:program][:longDescription]
        end

        it "updates the episode" do
          controller.send(:update_show, TabloConnect.tablo_ips[0], show.tablo_id, details)
          show.reload
          expect(show.episode).to eq details[:recEpisode][:jsonFromTribune][:program][:episodeNum]
        end

        it "updates the season" do
          controller.send(:update_show, TabloConnect.tablo_ips[0], show.tablo_id, details)
          show.reload
          expect(show.season).to eq details[:recEpisode][:jsonFromTribune][:program][:seasonNum]
        end

        it "updates the rec_date" do
          controller.send(:update_show, TabloConnect.tablo_ips[0], show.tablo_id, details)
          show.reload
          expect(show.rec_date).to eq details[:recEpisode][:jsonForClient][:airDate]
        end

        it "updates the air_date" do
          controller.send(:update_show, TabloConnect.tablo_ips[0], show.tablo_id, details)
          show.reload
          expect(show.air_date.strftime('%F')).to eq details[:recEpisode][:jsonForClient][:originalAirDate]
        end

        it "updates the image_id" do
          controller.send(:update_show, TabloConnect.tablo_ips[0], show.tablo_id, details)
          show.reload
          expect(show.image_id).to eq details[:recSeries][:imageJson][:images][0][:imageID]
        end
      end
    end
  end
end