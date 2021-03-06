module TabloConnect
  class Engine < ::Rails::Engine
    isolate_namespace TabloConnect

    config.generators do |g|
      g.test_framework :rspec
      g.fixture_replacement :factory_girl, :dir => 'spec/factories'
    end
  end

  class << self
    mattr_accessor :tablo_ips
    self.tablo_ips = ['127.0.0.1']

    mattr_accessor :tablo_port
    self.tablo_port = '180809'

    mattr_accessor :ffmpeg_path
    self.ffmpeg_path = '/usr/local/bin/ffmpeg'

    mattr_accessor :output_directory
    self.output_directory = '/tmp'
  end

  def self.setup(&block)
    yield self
  end
end
