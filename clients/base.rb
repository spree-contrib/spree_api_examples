require_relative '../setup'

module Clients
  class Base
    attr_accessor :conn, :last_response

    def initialize
      options = {
        url: 'http://localhost:3000',
        params: { token: 'fake' }
      }
      @conn = Faraday.new(options) do |f|
        f.request :multipart
        f.request :url_encoded
        f.adapter :httpclient
      end
    end

    def get(url, params={})
      @last_response = conn.get(url, params)
    end

    def post(url, params={})
      @last_response = conn.post(url, params) 
    end

    def put(url, params={})
      @last_response = conn.put(url, params)
    end

    def delete(url, params={})
      @last_response = conn.delete(url, params)
    end

    def succeeded(message)
      puts "[SUCCESS] #{message}".green
    end

    def failed(message)
      puts "[FAILURE] #{message} (#{last_response.status})".red
      errors = ::JSON.parse(last_response.body)
      if errors['error']
        puts errors['error']
        puts errors['errors']
      end
      puts "Error occurred at: " + caller[0]
      exit(1)
    end

    def pending(message)
      puts "[PENDING] #{message}".yellow
    end
  end
end
