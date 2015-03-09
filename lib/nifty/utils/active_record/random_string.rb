require 'securerandom'
require 'nifty/utils/random_string'

module Nifty
  module Utils
    module ActiveRecord
      module RandomString

        def self.included(base)
          base.extend ClassMethods
        end

        def self.random_string(type, opts = {})
          case type.to_sym
          when :uuid
            SecureRandom.uuid
          when :chars
            Nifty::Utils::RandomString.generate(opts)
          else
            SecureRandom.hex(opts[:length] || 24)
          end
        end

        module ClassMethods

          def has_random_strings?
            false
          end

          def random_string(field, options = {})
            self.send :include, ModelExtensions unless self.has_random_strings?
            self.random_string_fields[field] = options
          end

        end

        module ModelExtensions

          def self.included(base)
            base.extend ClassMethods
            base.before_validation :generate_random_strings
          end

          def generate_random_strings
            self.class.random_string_fields.each do |field, opts|
              if self.send(field).blank?
                if opts[:unique]
                  until self.send(field)
                    proposed_string = RandomString.random_string(opts[:type], opts)
                    unless self.class.where(field => proposed_string).exists?
                      self.send("#{field}=", proposed_string)
                    end
                  end
                else
                  self.send("#{field}=", RandomString.random_string(opts[:type], opts))
                end
              end
            end
          end

          module ClassMethods

            def random_string_fields
              @random_string_fields ||= {}
            end

            def has_random_strings?
              true
            end
          end

        end

      end
    end
  end
end
