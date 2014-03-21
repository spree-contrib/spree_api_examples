require 'bundler/setup'
require 'httmultiparty'
require 'pry'

class Client
  include HTTMultiParty
  base_uri 'http://localhost:3000/api'
end
