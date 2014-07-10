require_relative '../base'

module Examples
  module Checkout
    class CreatingWithLineItems
      def self.run(client)
        response = client.post('/api/orders', {
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
          order = JSON.parse(response.body)
          if order['line_items'].count == 1
            client.succeeded 'Order with line items created successfully.'
          else
            client.failed 'Order was created, but no line items were present.'
          end
        else
          client.failed 'Order could not be created.'
        end
      end
    end
  end
end

Examples.run(Examples::Checkout::CreatingWithLineItems)