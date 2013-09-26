module Nifty
  module Utils
    module ActiveRecord
      
      def self.included(base)
        base.extend ClassMethods
      end
      
      module ClassMethods
        
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
