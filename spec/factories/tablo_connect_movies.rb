FactoryGirl.define do
  factory :tablo_connect_movie, :class => 'TabloConnect::Movie' do
    sequence(:tablo_id) { |n| n }
    title "MyString"
    description "MyText"
    release_year 2011
    air_date "2015-11-01"
    image_id 1
    copy_status 0
  end
end
