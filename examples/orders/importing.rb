require_relative '../base'

# A little known feature of Spree: you can import entire Order objects.
# This is useful if you want to copy over your orders from another ecommerce platform.
# This is assuming that you know EXACTLY what you want to import.

########### DANGER, DANGER, DANGER #########
##                                        ##
##                                        ##
## You MUST be an admin to import orders. ##
##                                        ##
##                                        ##
########### DANGER, DANGER, DANGER #########

# If you attempt to do this as a normal user, you will only be able to:
# - add line items
# - add address information
#
# For users, payments and shipping data are automatically generated.
# Users MUST walkthrough the complete checkout without skipping a step.

module Examples
  module Orders
    class Importing
      def self.run(client)
        # First thing you might want to do is to create a user for this order.
        # The parameters below assume spree_auth_devise
        # These might be different if you're using a different authentication method.
        response = client.post('/api/users',
          {
            user: {
              email: "test#{rand(9999999)}@example.com",
              password: "password",
              password_confirmation: "password"
            }
          }
        )

        if response.status == 201
          user = JSON.parse(response.body)
          client.succeeded "User was created successfully."
        else
          client.failed "User could not be created"
        end

        # The next step is to add address information the order
        # This will be automatically linked to the user.
        # Before you make this request, you may need to make a request to one or both of:
        # - /api/countries
        # - /api/states
        # This will give you the correct country_id and state_id params to use for address information.

        # First, get the country:
        response = client.get('/api/countries?q[name_cont]=United States')
        if response.status == 200
          client.succeeded "Retrieved a list of countries."
          countries = JSON.parse(response.body)['countries']
          usa = countries.first
          if usa['name'] != 'United States'
            client.failed "Expected first country to be 'United States', but it wasn't."
          end
        else
          client.failed "Failed to retrieve a list of countries."
        end

        # Then, get the state we want from the states of that country:

        response = client.get("/api/countries/#{usa['id']}/states?q[name_cont]=Maryland")
        if response.status == 200
          client.succeeded "Retrieved a list of states."
          states = JSON.parse(response.body)['states']
          maryland = states.first
          if maryland['name'] != 'Maryland'
            client.failed "Expected first state to be 'Maryland', but it wasn't."
          end
        else
          client.failed "Failed to retrieve a list of states."
        end

        # We can finally submit some address information now that we have it all:

        address = {
          firstname: 'Test',
          lastname: 'User',
          address1: 'Unit 1',
          address2: '1 Test Lane',
          country_id: usa['id'],
          state_id: maryland['id'],
          city: 'Bethesda',
          zipcode: '20814',
          phone: '(555) 555-5555'
        }

        response = client.post('/api/orders', {
          order: {
            user_id: user["id"],
            completed_at: Date.today.to_s,
            line_items: {
              "0" => {
                variant_id: 1,
                quantity: 5
              }
            },
            bill_address_attributes: address,
            ship_address_attributes: address,
            shipments: [
              {
                # The tracking number for this shipment (if there is one)
                tracking: 'H12345',
                stock_location: 'default', # Actual stock location name as per the database
                shipping_method: 'UPS Ground (USD)', # Actual shipping method as per the database
                cost: 5,
                inventory_units: [
                  variant_id: 1
                ]
              }
            ],
            payments: [
              amount: 19.99,
              payment_method: 'Credit Card'
            ],
            # Apply a negative adjustment for the cost of the line item:
            adjustments_attributes: [
              {
                label: 'Some sort of discount',
                amount: -10
              }
            ]
            #
            # These adjustments are not assignable to specific items within the order through this API.
            # That's even though we support this feature in Spree 2.2.
          }
        })

        if response.status == 201
          order = JSON.parse(response.body)
          client.succeeded 'Order has been successfully imported.'
          if order["user_id"] == user["id"]
            client.succeeded 'User was correctly associated with this order.'
          else
            client.failed 'Expected order to be associated with a user, but it was not.'
          end
        else
          client.failed 'Order failed to import.'
        end
      end
    end
  end
end

Examples.run(Examples::Orders::Importing)
