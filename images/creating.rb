require_relative '../client'

image = File.open(File.dirname(__FILE__) + '/thinking-cat.jpg')

# Adding an image to a product's master variant
response = Client.post('/products/1/images',
  query: {
    token: 'fake'
  },
  body: {
    image: {
      attachment: image
    }
  }
)

if response.code != 200
  puts "[ERROR] Could not create an image for a product (#{response.code})"
else
  puts "[SUCCESS] Created an image for a product."
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
