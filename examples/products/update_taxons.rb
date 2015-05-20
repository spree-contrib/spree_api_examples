require_relative '../base'

module Examples
  module Products
    class UpdateTaxons
      def self.run(client)

        # create a new product
        response = client.post("/api/products",
          {
            product: {
              name: 'Taxon Product',
              price: 9.99,
              shipping_category_id: 1
            }
          }
        )

        if response.status == 201
          client.succeeded "Created a product."
          product = JSON.parse(response.body)
          id = product['id']

          if product['name'] != 'Taxon Product'
            client.failed "Product name does not match expected value. #{product.inspect}"
          end
        else
          client.failed "Could not create product (#{response.status})"
          exit(1)
        end


        # fetch newly created product
        response = client.get("/api/products/#{id}")

        if response.status == 200
          client.succeeded "Fetched newly created product."
        else
          client.failed "Failed to fetch newly created product (#{response.status})"
          exit(1)
        end

        #update newly created product
        response = client.put("/api/products/#{id}",
          {
            product: {
              name: 'Taxon Prod',
              taxon_ids: [9]
            }
          }
        )

        if response.status == 200
          client.succeeded "Updated product."

          product = JSON.parse(response.body)
          if product['taxon_ids'] != [9]
            client.failed "Product Taxons does not match expected value. #{product.inspect}"
          end
        else
          client.failed "Failed to update product (#{response.status})"
          exit(1)
        end
      end
    end
  end
end

Examples.run(Examples::Products::UpdateTaxons)
