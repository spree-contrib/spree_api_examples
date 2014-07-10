require 'bundler/setup'
require 'faraday'
require 'json'
require 'pry'

class Client
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

  def delete(url, params={})
    @last_response = conn.delete(url, params)
  end

  def succeeded(message)
    puts "[SUCCESS] #{message}"
  end

  def failed(message)
    puts "[FAILURE] #{message} (#{last_response.status})"
    errors = JSON.parse(last_response.body)
    if errors['error']
      puts errors['error']
      puts errors['errors']
    end
    puts "Error occurred at: " + caller[0]
    exit(1)
  end
end
