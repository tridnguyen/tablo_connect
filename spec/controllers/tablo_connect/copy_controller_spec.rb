require 'spec_helper'

module TabloConnect
  describe CopyController, type: :controller do
    routes { TabloConnect::Engine.routes }

    let!(:show) { FactoryGirl.create(:tablo_connect_show, show: 'Angle of Attack') }

    describe "GET index" do
      before do
        allow(controller).to receive(:spawn).and_return(1234)
        allow(controller).to receive(:destination_path).and_return('/tmp/output.mp4')
        allow(Process).to receive(:detach)
      end

      context "when the item is not found" do
        it "returns a 404" do
          get :index, {tablo_id: 99999, type: 'some_type'}
          expect(response.status).to eq 404
        end
      end

      context "when the item is found" do
        it "returns a 200" do
          get :index, {tablo_id: show.tablo_id, type: 'show'}
          expect(response.status).to eq 200
        end

        it "calls spawn" do
          expect(controller).to receive(:spawn)
          get :index, {tablo_id: show.tablo_id, type: 'show'}
        end

        it "sets the copy_status to in_progress" do
          item = TabloConnect::Show.find_by_tablo_id show.tablo_id
          expect(item.copy_status).to eq('idle')
          get :index, {tablo_id: show.tablo_id, type: 'show'}
          item.reload
          expect(item.copy_status).to eq('in_progress')
        end

        it "returns an object with a shows array" do
          get :index, {tablo_id: show.tablo_id, type: 'show'}
          json_body = JSON.parse(response.body).with_indifferent_access
          expect(json_body).to match({pid: 1234, destination: '/tmp/output.mp4'})
        end
      end
    end

    describe "GET status" do
      it "calls file_copy_status" do
        expect(controller).to receive(:file_copy_status)
        get :status, {tablo_id: show.tablo_id, type: 'show'}
      end

      it "returns a 200 status code" do
        get :status, {tablo_id: show.tablo_id, type: 'show'}
        expect(response.status).to eq 200
      end

      it "returns a JSON object with the copy_status" do
        get :status, {tablo_id: show.tablo_id, type: 'show'}
        json_body = JSON.parse(response.body).with_indifferent_access
        expect(json_body[:copy_status]).to eq show.copy_status
      end
    end

    describe ".set_item" do
      before do
        allow(controller).to receive(:head).and_return(double.as_null_object)
      end

      context "when the type is not show or movie" do
        it "returns a 404" do
          allow(controller).to receive(:params).and_return({tablo_id: show.tablo_id, type: 'invalid_type'})
          expect(controller).to receive(:head).with(:not_found)
          controller.send(:set_item)
        end
      end

      context "when the type is 'show' or 'movie'" do
        context "when the type is 'movie'" do
          it "uses the Movie model" do
            allow(controller).to receive(:params).and_return({tablo_id: show.tablo_id, type: 'movie'})
            expect(TabloConnect::Movie).to receive(:find_by_tablo_id).with(show.tablo_id)
            controller.send(:set_item)
          end
        end

        context "when the type is 'show'" do
          it "uses the Show model" do
            allow(controller).to receive(:params).and_return({tablo_id: show.tablo_id, type: 'show'})
            expect(TabloConnect::Show).to receive(:find_by_tablo_id).with(show.tablo_id)
            controller.send(:set_item)
          end
        end

        context "when the item is not found" do
          it "returns a 404" do
            allow(controller).to receive(:params).and_return({tablo_id: 99999, type: 'show'})
            controller.send(:set_item)
          end
        end

        context "when the item is found" do
          it "sets the @item instance variable" do
            allow(controller).to receive(:params).and_return({tablo_id: show.tablo_id, type: 'show'})
            controller.send(:set_item)
            item = controller.instance_variable_get(:@item)
            expect(item).to match(show)
          end
        end
      end
    end

    describe ".source_path" do
      it "builds the source_path with the tablo_id" do
        controller.instance_variable_set(:@item, show)
        path = controller.send(:source_path)
        expect(path).to eq "#{TabloConnect.tablo_base_url}/pvr/#{show.tablo_id}/pl/playlist.m3u8"
      end
    end

    describe ".destination_path" do
      it "builds the destination path with the file_name method" do
        controller.instance_variable_set(:@item, show)
        allow(controller).to receive(:file_name).and_return('output.mp4')
        path = controller.send(:destination_path)
        expect(path).to eq "#{TabloConnect.output_directory}/output.mp4"
      end
    end

    describe ".ffmpeg_copy" do
      it "returns the ffmpeg copy command string" do
        allow(controller).to receive(:source_path).and_return('/source/path/input.mp4')
        allow(controller).to receive(:destination_path).and_return('/destination/path/output.mp4')
        expect(controller.send(:ffmpeg_copy)).to eq "#{TabloConnect.ffmpeg_path} -i \"/source/path/input.mp4\" -bsf:a aac_adtstoasc -vcodec copy -c copy /destination/path/output.mp4"
      end
    end

    describe ".file_name" do
      before do
        controller.instance_variable_set(:@item, show)
      end

      context "when type is 'movie'" do
        it "returns the unix safe movie file name" do
          allow(controller).to receive(:params).and_return({type: 'movie'})
          expect(controller.send(:file_name)).to eq('The_Harder_They_Fall.mp4')
        end
      end

      context "when type is 'show'" do
        it "returns the unix safe show file name" do
          allow(controller).to receive(:params).and_return({type: 'show'})
          expect(controller.send(:file_name)).to eq("Angle_of_Attack.s01e01_#{show.tablo_id}.mp4")
        end
      end
    end

    describe ".file_copy_status" do
      before do
        controller.instance_variable_set(:@item, show)
      end

      context "when the file exists" do
        before do
          allow(controller).to receive(:destination_path).and_return(Rails.root.join('public', '404.html').to_s)
        end

        context "when the file is in use" do
          it "updates the copy_status to :in_progress" do
            allow(controller).to receive(:file_unlocked?).and_return(false)
            controller.send(:file_copy_status)
            expect(show.copy_status).to eq 'in_progress'
          end
        end

        context "when the file is not in use" do
          it "updates the copy_status to :complete" do
            allow(controller).to receive(:file_unlocked?).and_return(true)
            controller.send(:file_copy_status)
            expect(show.copy_status).to eq 'complete'
          end
        end

        context "when the new_status is equal to the current status" do
          it "does not update the copy_status" do
            allow(controller).to receive(:file_unlocked?).and_return(true)
            show.copy_status = :complete
            show.save
            expect(show.copy_status).to eq 'complete'
            expect(controller).to_not receive(:update_copy_status).with(:complete)
            controller.send(:file_copy_status)
            expect(show.copy_status).to eq 'complete'
          end
        end
      end

      context "when the file does not exist" do
        before do
          allow(controller).to receive(:destination_path).and_return(Rails.root.join('public', 'non_existent.html').to_s)
        end

        it "updates the copy_status to :idle" do
          show.copy_status = :in_progress
          show.save!
          expect(show.copy_status).to eq 'in_progress'
          controller.send(:file_copy_status)
          expect(show.copy_status).to eq 'idle'
        end
      end
    end

    describe ".new_status" do
      context "when file does not exist" do
        it "returns :idle" do
          allow(File).to receive(:exists?).and_return(false)
          expect(controller.send(:new_status)).to eq :idle
        end
      end

      context "when file exists" do
        before do
          allow(File).to receive(:exists?).and_return(true)
        end

        context "when file is not in use" do
          it "returns :complete" do
            allow(controller).to receive(:file_unlocked?).and_return(true)
            expect(controller.send(:new_status)).to eq :complete
          end
        end

        context "when file is in use" do
          it "returns :in_progress" do
            allow(controller).to receive(:file_unlocked?).and_return(false)
            expect(controller.send(:new_status)).to eq :in_progress
          end
        end
      end
    end
  end
end