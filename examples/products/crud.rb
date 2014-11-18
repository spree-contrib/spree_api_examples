require_relative '../base'

module Examples
  module Products
    class CRUD
      def self.run(client)

        # create a new product
        response = client.post("/api/products",
          {
            product: {
              name: 'Brians Product',
              price: 9.99,
              shipping_category_id: 1
            }
          }
        )

        if response.status == 201
          client.succeeded "Created a product."
          product = JSON.parse(response.body)
          id = product['id']

          if product['name'] != 'Brians Product'
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
              sku: 'BDQ-1234'
            }
          }
        )

        if response.status == 200
          client.succeeded "Updated product."

          product = JSON.parse(response.body)

          if product['master']['sku'] != 'BDQ-1234'
            client.failed "Product SKU does not match expected value. #{product.inspect}"
          end
        else
          client.failed "Failed to update product (#{response.status})"
          exit(1)
        end

        # delete our lovely product
        response = client.delete("/api/products/#{id}")
        if response.status == 204
          client.succeeded "Deleted product."
        else
          client.failed "Failed to delete product (#{response.status})"
          exit(1)
        end
      end
    end
  end
end

Examples.run(Examples::Products::CRUD)
