require_relative '../client'
client = Client.new

# Create the order step by step:
# You may also choose to start it off with some line items
# See checkout/creating_with_line_items.rb
response = client.post('/api/orders',
  {
    order: {
      # email: 'spree@example.com'#,
      user_id: 2
    }
  }
)

if response.status == 201
  puts "[SUCCESS] Created new checkout."
  order = JSON.parse(response.body)
  puts order.inspect
  if order['email'] == 'spree@example.com'
    # Email addresses are necessary for orders to transition to address.
    # This just makes really sure that the email is already set.
    # You will not have to do this in your own API unless you've customized it.
    client.succeeded 'Email set automatically on order successfully.'
  else
    client.failed %Q{
Email address was not automatically set on order.'
  -> This may lead to problems transitioning to the address step.
    }
  end
else
  client.failed 'Failed to create a new blank checkout.'
end
