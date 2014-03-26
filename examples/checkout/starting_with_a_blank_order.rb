require_relative '../client'

# Create the order
client = Client.new
response = client.post('/api/checkouts')

if response.status == 201
  puts "[SUCCESS] Created new checkout."
  order = JSON.parse(response.body)
  if order['email'] == 'spree@example.com'
    puts '[SUCCESS] Email set automatically on order successfully.'
  else
    puts ""
else
  puts "[FAILURE] Failed to create a new blank checkout."
  exit(1)
end

# Assign a line item to the order we just created.

response = client.post("/api/orders/#{order['number']}/line_items",
  {
    line_item: {
      variant_id: 1,
      quantity: 1
    }
  }
)

if response.status == 201
  puts "[SUCCESS] Added a line item."
else
  puts "[FAILURE] Failed to add a line item. (#{response.status})"
  exit(1)
end

