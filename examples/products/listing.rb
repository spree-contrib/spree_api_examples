require_relative '../base'

module Examples
  module Products
    class Listing
      def self.run(client)
        response = client.get('/api/products')
        if response.status == 200
          client.succeeded "Retrieved a list of products"
        else
          client.failed "Failed to retrieve a list a products (#{response.status})"
        end
      end
    end
  end
end

Examples.run(Examples::Products::Listing)
