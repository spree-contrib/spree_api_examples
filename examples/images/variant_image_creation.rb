require_relative '../base'

module Examples
  module Images
    class VariantImageCreation
      def self.run(client)
        if Clients::JSON === client
          client.pending "VariantImageCreation does not work with JSON client."
          return
        end

        image = File.dirname(__FILE__) + '/thinking-cat.jpg'
        attachment = Faraday::UploadIO.new(image, 'image/jpeg')

        # Adding an image to a variant
        response = client.post('/api/variants/1/images',
          {
            image: {
              attachment: attachment
            }
          }
        )

        if response.status == 201
          client.succeeded "Created an image for a variant"
          image = JSON.parse(response.body)
          # Undo! Undo! Undo!
          delete_response = client.delete("/api/variants/1/images/#{image["id"]}")
          if delete_response.status == 204
            client.succeeded "Deleted the image we just created."
          else
            client.failed "Could not delete the image we just created (#{delete_response.status})"
          end
        else
          client.failed "Could not create an image for a variant (#{response.status})"
        end
      end
    end
  end
end

Examples.run(Examples::Images::VariantImageCreation)