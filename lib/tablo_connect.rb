require "tablo_connect/engine"

module TabloConnect
  def self.tablo_base_url(tablo_ip)
    "http://#{tablo_ip}:#{TabloConnect.tablo_port}"
  end
end
