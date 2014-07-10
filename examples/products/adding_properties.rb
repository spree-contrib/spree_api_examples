require_relative '../base'

module Examples
  module Products
    class AddingProperties
      def self.run(client)
        response = client.put('/api/products/1',
          {
            product: {
              product_properties_attributes: [
                { 
                  property_name: 'brand',
                  value: 'Brand Name'
                }
              ]
            }
          }
        )

        product = JSON.parse(response.body)
        new_property = product["product_properties"].detect { |p| p["property_name"] == "brand" }
        if new_property && new_property["value"] == "Brand Name"
          client.succeeded "Property created successfully."

          response = client.put('/api/products/1',
            {
              product: {
                product_properties_attributes: [
                  { 
                    id: new_property["id"],
                    property_name: 'brand',
                    value: 'Name Brand'
                  }
                ]
              }
            }
          )

          product = JSON.parse(response.body)
          brand_product_properties = product["product_properties"].select { |p| p["property_id"] == new_property["property_id"] }
          if brand_product_properties.count == 1
            client.succeeded "Property did not duplicate itself."
            # Undo! Undo! Undo!
            client.delete("/api/products/1/product_properties/#{new_property["id"]}")
          else
            # Undo! Undo! Undo!            
            brand_product_properties.each do |property|
              client.delete("/api/products/1/product_properties/#{property["id"]}")
            end
            # Necessary because client.failed needs some JSON for the last request.
            client.get('/api/products/1')
            client.failed "There are two properties called 'Name Brand', when there should only be one."
          end
        else
          client.failed "Property was not created successfully."
        end
      end
    end
  end
end

Examples.run(Examples::Products::AddingProperties)