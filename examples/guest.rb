require_relative '../clients/guest'

module Examples
  def self.run(example)
    clients = []
    clients << Clients::Guest.new

    clients.each do |client|
      message = "Running #{example.name} with #{client.class.name}"
      puts message
      puts "-" * message.length

      example.run(client)
    end
  end
end
