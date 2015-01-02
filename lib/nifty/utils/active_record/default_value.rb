module Nifty
  module Utils
    module ActiveRecord
      module DefaultValue

        def self.included(base)
          base.extend ClassMethods
        end

        module ClassMethods

          def has_default_values?
            false
          end

          def default_value(field, block, options = {})
            self.send :include, ModelExtensions unless self.has_default_values?
            self.default_value_definitions[field] = options.merge(:block => block)
          end

        end

        module ModelExtensions

          def self.included(base)
            base.extend ClassMethods
            base.before_validation :_set_default_values
          end

          def _set_default_values
            self.class.default_value_definitions.each do |field, opts|
              if self.send(field).blank?
                proposed_value = self.instance_exec(&opts[:block])
                self.send("#{field}=", proposed_value)
              end
            end
          end

          module ClassMethods

            def default_value_definitions
              @default_value_definitions ||= {}
            end

            def has_default_values?
              true
            end

          end

        end

      end
    end
  end
end
