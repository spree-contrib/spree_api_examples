require_relative '../../base'

module Examples
  module Products
    module Variants
      class CRUD
        def self.run(client)

          ov_id = nil

          # create a new product
          response = client.post("/api/v1/products",
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
          response = client.post("/api/v1/option_types",
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
            response = client.post("/api/v1/option_types/#{ot_id}/option_values",
              {
                option_value: {
                  name: level,
                  presentation: level.capitalize
                }
              }
            )

            if response.status == 201
              client.succeeded "Created an option value."
              ov = JSON.parse(response.body)
              ov_id = ov['id']
            else
              client.failed "Could not create option value (#{response.status})"
              exit(1)
            end
          end

          # Update product with option types
          response = client.put("/api/v1/products/#{id}",
            {
              product: {
                option_types: [ot_id]
              }
            }
          )

          if response.status == 200
            client.succeeded "Updated product."

            product = JSON.parse(response.body)
          else
            client.failed "Failed to update product (#{response.status})"
            exit(1)
          end

          # Create variant
          response = client.post("/api/v1/products/#{id}/variants",
            {
              variant: {
                option_value_ids: [ov_id]
              }
            }
          )

          if response.status == 201
            variant = JSON.parse(response.body)
            if variant['option_values'].empty?
              client.failed "Failed to assign option value (#{response.status})"
              exit(1)
            else
              client.succeeded "Created Variant."
            end
          else
            client.failed "Failed to create variant (#{response.status})"
            exit(1)
          end

        end
      end
    end
  end
end

Examples.run(Examples::Products::Variants::CRUD)
