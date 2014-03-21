require_relative '../client'

image = File.dirname(__FILE__) + '/thinking-cat.jpg'
attachment = Faraday::UploadIO.new(image, 'image/jpeg')

client = Client.new

# Adding an image to a variant
response = client.post('/api/variants/1/images',
  {
    image: {
      attachment: attachment
    }
  }
)

if response.status == 201
  puts "[SUCCESS] Created an image for a variant"
  image = JSON.parse(response.body)
  # Undo! Undo! Undo!
  delete_response = client.delete("/api/variants/1/images/#{image["id"]}")
  if delete_response.status == 204
    puts "[SUCCESS] Deleted the image we just created."
  else
    puts "[FAILURE] Could not delete the image we just created (#{delete_response.status})"
    exit(1)
  end
else
  puts "[FAILURE] Could not create an image for a variant (#{response.status})"
  exit(1)
end