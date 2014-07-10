require_relative '../clients/base'
require_relative '../clients/json'

module Examples
  def self.run(example)
    clients = []
    clients << Clients::Base.new
    clients << Clients::JSON.new

    clients.each do |client|
      message = "Running #{example.name} with #{client.class.name}"
      puts message
      puts "-" * message.length

      example.run(client)
    end
  end
end