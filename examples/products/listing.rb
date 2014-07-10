require_relative '../base'

module Examples
  module Products
    class Listing
      response = client.get('/api/products')
      if response.status == 200
        puts "[SUCCESS] Retrieved a list of products"
      else
        puts "[FAILURE] Failed to retrieve a list a products (#{response.status})"
      end
    end
  end
end

Examples.run(Examples::Products::Listing)