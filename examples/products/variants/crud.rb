require_relative '../../base'

module Examples
  module Products
    module Variants
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
          else
            client.failed "Could not create product (#{response.status})"
            exit(1)
          end

          # create option type
          response = client.post("/api/option_types",
            {
              option_type: {
                name: 'level',
                presentation: 'Level'
              }
            }
          )

          if response.status == 201
            client.succeeded "Created an option type."
            ot = JSON.parse(response.body)
            ot_id = ot['id']
          else
            client.failed "Could not create option type (#{response.status})"
            exit(1)
          end

          %w{one two}.each do |level|
            # create option type
            response = client.post("/api/option_types/#{ot_id}/option_values",
              {
                option_value: {
                  name: level,
                  presentation: level.capitalize
                }
              }
            )

            if response.status == 201
              client.succeeded "Created an option value."
            else
              client.failed "Could not create option value (#{response.status})"
              exit(1)
            end
          end

          #TODO: There's no API for assigning option_types to products

        end
      end
    end
  end
end

Examples.run(Examples::Products::Variants::CRUD)
