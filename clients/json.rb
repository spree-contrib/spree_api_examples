require_relative 'base'

module Clients
  class JSON < Base

    def post(url, params={})
      @last_response = conn.post do |req|
        req.url url
        req.headers['Content-Type'] = 'application/json'
        req.body = params.to_json
      end
    end

    def put(url, params={})
      @last_response = conn.put do |req|
        req.url url
        req.headers['Content-Type'] = 'application/json'
        req.body = params.to_json
      end
    end
  end
end
