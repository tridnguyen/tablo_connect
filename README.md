#TabloConnect
[TabloConnect](http://tridnguyen.github.io/tablo_connect/) is a rails engine that connects to Tablo DVRs and provides listings of recordings as well as video export.

##Requirements
* This is a rails engine.  So, you'll need to add it an existing or new rails project.
* [ffmpeg](https://www.ffmpeg.org/) is required for copying and combining video segments from the tablo to your local machine.

##Installation
###Add to your Gemfile:

```ruby
gem 'tablo_connect'
```

###Add an initializer file in your rails project (tablo_connect.rb) with the following:

```ruby
TabloConnect.setup do |config|
  config.tablo_ip = '192.168.1.9'
  config.tablo_port = '18080'
  config.ffmpeg_path = '/usr/local/bin/ffmpeg'
  config.output_directory = '/path/to/download/directory'
end
```

###Install the migrations
```bundle exec rake tablo_connect:install:migrations```

###Run the migrations
```bundle exec rake db:migrate```

###Start the server:
```rails s```

###View in your browser:

```
http://localhost:3000/tablo
```

##Upcoming Features
* Automate stripping commercials using comskip and MEncoder

##Contributing
When submitting pull requests, please include rspecs and karma unit tests for any new code.  Please do not submit pull requests
until rspecs and karma unit tests are all green.
