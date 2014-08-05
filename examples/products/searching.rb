require_relative '../base'

module Examples
  module Products
    class Searching
      def self.run(client)
        response = client.get('/api/products?q[variants_including_master_sku_cont]=RUB')
        products = JSON.parse(response.body)

        if response.status == 200 && products['products'].first
          client.succeeded "Retrieved a list of products with sku containing RUB"
        else
          client.failed "Failed to retrieve a list a products (#{response.status})"
        end
      end
    end
  end
end

Examples.run(Examples::Products::Searching)
