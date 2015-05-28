
require 'net/http'

class HttpRequester

  def request(url_host, req)
    Net::HTTP.new(url_host).request(req)
  end

end

