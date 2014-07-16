require_relative '../base'

module Examples
  module Images
    class ProductImageCreation
      def self.run(client)
        if Clients::JSON === client
          client.pending "ProductImageCreation does not work with JSON client."
          return
        end

        image = File.dirname(__FILE__) + '/thinking-cat.jpg'
        attachment = Faraday::UploadIO.new(image, 'image/jpeg')

        # Adding an image to a product's master variant
        response = client.post('/api/products/1/images',
          {
            image: {
              attachment: attachment
            }
          }
        )

        if response.status == 201
          client.succeeded "Created an image for a product."
          image = JSON.parse(response.body)
          # Undo! Undo! Undo!
          delete_response = client.delete("/api/products/1/images/#{image["id"]}")
          if delete_response.status == 204
            client.succeeded "Deleted the image we just created."
          else
            client.failed "Could not delete the image we just created (#{delete_response.status})"
            exit(1)
          end
        else
          client.failed "Could not create an image for a product (#{response.status})"
          exit(1)
        end
      end
    end
  end
end

Examples.run(Examples::Images::ProductImageCreation)