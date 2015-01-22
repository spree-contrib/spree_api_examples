require_relative '../base'

# TODO: Need to set: Spree::Config[:auto_capture] = true

module Examples
  module Api
    class ChangeShipmentContents
      def self.run(client)

        # Create the order step by step:
        # You may also choose to start it off with some line items
        # See checkout/creating_with_line_items.rb
        response = client.post('/api/orders')

        if response.status == 201
          order = JSON.parse(response.body)
          client.succeeded "Created new checkout. - #{order['number']}"
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

        # Assign a line item to the order we just created.

        response = client.post("/api/orders/#{order['number']}/line_items",
        {
          line_item: {
            variant_id: 1,
            quantity: 2
          }
        }
        )

        response = client.post("/api/orders/#{order['number']}/line_items",
        {
          line_item: {
            variant_id: 2,
            quantity: 2
          }
        }
        )


        if response.status == 201
          client.succeeded "Added a line item."
        else
          client.failed "Failed to add a line item."
        end

        # Transition the order to the 'address' state
        response = client.put("/api/checkouts/#{order['number']}/next")
        if response.status == 200
          order = JSON.parse(response.body)
          client.succeeded "Transitioned order into address state."
        else
          client.failed "Could not transition order to address state."
        end

        # We can finally submit some address information now that we have it all:

        address = {
          first_name: 'Test',
          last_name: 'User',
          address1: 'Unit 1',
          address2: '1 Test Lane',
          country_id: 232, # usa
          state_id: 3431, # maryland,
          city: 'Bethesda',
          zipcode: '20814',
          phone: '(555) 555-5555'
        }

        response = client.put("/api/checkouts/#{order['number']}",
        {
          order: {
            bill_address_attributes: address,
            ship_address_attributes: address
          }
        }
        )

        if response.status == 200
          client.succeeded "Address details added."
          order = JSON.parse(response.body)
          if order['state'] == 'delivery'
            client.succeeded "Order automatically transitioned to 'delivery'."
          else
            client.failed "Order failed to automatically transition to 'delivery'."
          end
        else
          client.failed "Could not add address details to order."
        end

        # Next step: delivery!

        first_shipment = order['shipments'].first
        response = client.put("/api/checkouts/#{order['number']}",
        {
          order: {
            shipments_attributes: [
              id: first_shipment['id'],
              selected_shipping_rate_id: first_shipment['shipping_rates'].first['id']
            ]
          }
        }
        )

        if response.status == 200
          client.succeeded "Delivery options selected."
          order = JSON.parse(response.body)
          if order['state'] == 'payment'
            client.succeeded "Order automatically transitioned to 'payment'."
          else
            client.failed "Order failed to automatically transition to 'payment'."
          end
        else
          client.failed "The store was not happy with the selected delivery options."
        end

        # Next step: payment!

        # First up: a credit card payment
        credit_card_payment_method = order['payment_methods'].first

        response = client.put("/api/checkouts/#{order['number']}",
        {
          order: {
            payments_attributes: [{
              payment_method_id: credit_card_payment_method['id']
              }],
            },
            payment_source: {
              credit_card_payment_method['id'] => {
                number: '4111111111111111',
                month: '1',
                year: '2017',
                verification_value: '123',
                name: 'Jay Smith',
              }
            }
        })

        if response.status == 200
          order = JSON.parse(response.body)
          client.succeeded "Payment details provided for the order."
          # Order will transition to the confirm state only if the selected payment
          # method allows for payment profiles.
          # The dummy Credit Card gateway in Spree does, so confirm is shown for this order.
          if order['state'] == 'confirm'
            client.succeeded "Order automatically transitioned to 'confirm'."
          else
            client.failed "Order did not transition automatically to 'confirm'."
          end
        else
          client.failed "Payment details were not accepted for the order."
        end

        # This is the final point where the user gets to view their order's final information.
        # All that's required at this point is that we complete the order, which is as easy as:

        response = client.put("/api/checkouts/#{order['number']}/next")
        if response.status == 200
          order = JSON.parse(response.body)
          if order['state'] == 'complete'
            client.succeeded "Order complete!"
          else
            client.failed "Order did not complete."
          end
        else
          client.failed "Order could not transition to 'complete'."
        end

        puts JSON.pretty_generate(order)

        if order['shipments'].any? { |s| s['state'] != 'ready' }
          client.failed "Shipments are not ready"
        end

        # Remove a variants

        shipment = order['shipments'].first
        variant_id = shipment['manifest'].first['variant_id']
        response = client.put("/api/shipments/#{shipment['number']}/remove?variant_id=#{variant_id}&quantity=1")
        if response.status == 200
          client.succeeded "Remove variant call was successful"
        end
        shipment = JSON.parse(response.body)
        puts JSON.pretty_generate(shipment)

        # Add a variant

        shipment = order['shipments'].last
        variant_id = shipment['manifest'].first['variant_id']
        response = client.put("/api/shipments/#{shipment['number']}/add?variant_id=#{variant_id}&quantity=1")
        if response.status == 200
          client.succeeded "Add variant call was successful"
        end
        shipment = JSON.parse(response.body)
        puts JSON.pretty_generate(shipment)
      end
    end
  end
end

Examples.run(Examples::Api::ChangeShipmentContents)
