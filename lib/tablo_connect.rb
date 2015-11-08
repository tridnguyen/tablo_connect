require "tablo_connect/engine"

module TabloConnect
  def self.tablo_base_url
    "http://#{TabloConnect.tablo_ip}:#{TabloConnect.tablo_port}"
  end
end
