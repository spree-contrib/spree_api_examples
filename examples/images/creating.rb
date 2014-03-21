require_relative '../client'

image = File.dirname(__FILE__) + '/thinking-cat.jpg'

client = Client.new

# Adding an image to a product's master variant
response = client.post('/api/products/1/images',
  {
    image: {
      attachment: Faraday::UploadIO.new(image, 'image/jpeg')
    }
  }
)

if response.status == 201
  puts "[SUCCESS] Created an image for a product."
  image = JSON.parse(response.body)
  # Undo! Undo! Undo!
  delete_response = client.delete("/api/products/1/images/#{image["id"]}")
  if delete_response.status == 204
    puts "[SUCCESS] Deleted the image we just created."
  else
    puts "[FAILURE] Could not delete the image we just created (#{delete_response.status})"
    exit(1)
  end
else
  puts "[ERROR] Could not create an image for a product (#{response.status})"
end

# puts "Adding an image to a variant..."
# # Adding an image to a variant
# response = Client.post('/variant/1/images',
#   body: {
#     image: {
#       attachment: image
#     }
#   }
# )

# if response.code != 200
#   puts "[ERROR] Could not create an image for a variant (#{response.code})"
# else
#   puts "[SUCCESS] Created an image for a variant."
# end
