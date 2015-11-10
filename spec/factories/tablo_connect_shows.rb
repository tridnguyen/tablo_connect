FactoryGirl.define do
  factory :tablo_connect_show, :class => 'TabloConnect::Show' do
    sequence(:tablo_id) { |n| n }
    show "Three's Company"
    title "The Harder They Fall"
    description "Lorem Ipsum Dolor Sit Emit"
    episode 1
    season 1
    air_date "2015-11-01"
    rec_date "2015-11-01"
    image_id 1
    copy_status 0
    tablo_ip "127.0.0.1"
  end
end
