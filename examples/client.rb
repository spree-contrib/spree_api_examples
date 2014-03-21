require 'bundler/setup'
require 'faraday'
require 'json'
require 'pry'

class Client
  attr_accessor :conn
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

  def post(url, params={})
    conn.post(url, params) 
  end

  def delete(url, params={})
    conn.delete(url, params)
  end
end
