module Nifty
  module Utils
    module ActiveRecord
      module Inquirer

        #:nodoc:
        def self.included(base)
          base.extend ClassMethods
        end

        module ClassMethods

          # Allows you to automatically create inquiry methods for string field. For example, if you have
          # an Order model which has a status field containing 'approved' or 'delivered' you may wish to
          # have a #approved? or #delivered? method on the model.
          #
          #   class Order < ActiveRecord::Baser
          #     STATUSES = ['approved', 'delivered']
          #     inquirer :status, *STATUSES
          #   end
          #
          #   order = Order.new(:status => 'approved')
          #   order.approved?       #=> true
          #   order.delivered?      #=> false
          #
          #
          def inquirer(field, *options)
            options.each do |option|
              define_method "#{option}?" do
                self.read_attribute(field).to_s == option.to_s
              end
            end
          end

        end

      end
    end
  end
end
