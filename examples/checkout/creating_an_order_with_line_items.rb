require_relative '../client'

client = Client.new
response = client.post('/api/checkouts', {
  order: {
    # Repeat the elements in this hash for as many line items as you please.
    line_items: {
      "0" => {
        variant_id: 1,
        quantity: 5
      }
    }
  }
})

if response.status == 201
  puts "[SUCCESS] Created new checkout."
else
  puts "[FAILURE] Failed to create a new blank checkout."
  exit(1)
end