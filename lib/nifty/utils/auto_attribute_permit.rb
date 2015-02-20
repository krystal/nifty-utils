module Nifty
  module Utils
    module AutoAttributePermit

      def self.setup
        ActionView::Helpers::FormBuilder.send :include, FormBuilderExtensions
        ActionController::Parameters.send :include, StrongParameterExtensions
      end

      def self.verifier
        @verifier ||= ActiveSupport::MessageVerifier.new(Rails.application.secrets.secret_key_base)
      end

      module StrongParameterExtensions
        def self.included(base)
          base.class_eval do
            alias_method_chain :permit, :auto_attribute_permit
          end
        end

        def permit_with_auto_attribute_permit(*filters)
          if filters.delete(:auto)
            fields = AutoAttributePermit.verifier.verify(self['permitted_fields'])
            permit_without_auto_attribute_permit(*(fields | filters))
          else
            permit_without_auto_attribute_permit(*filters)
          end
        end
      end

      module FormBuilderExtensions
        def self.included(base)
          base.class_eval do
            alias_method_chain :label, :auto_attribute_permit
            alias_method_chain :submit, :auto_attribute_permit
          end
        end

        def auto_permitted_attributes
          @auto_permitted_attributes ||= []
        end

        def label_with_auto_attribute_permit(method, text = nil, options = {}, &block)
          auto_permitted_attributes << method unless (text.is_a?(Hash) ? text : options)[:auto_permit] == false
          label_without_auto_attribute_permit(method, text, options, &block)
        end

        def submit_with_auto_attribute_permit(value = nil, options = {})
          value, options = nil, value if value.is_a?(Hash)
          include_permit_field = options.delete(:include_auto_permit_field)
          submit_button = submit_without_auto_attribute_permit(value, options)
          unless include_permit_field == false
            submit_button.safe_concat(self.auto_permitted_attributes_field)
          else
            submit_button
          end
        end

        def encoded_auto_permitted_attributes
          AutoAttributePermit.verifier.generate(auto_permitted_attributes)
        end

        def auto_permitted_attributes_field
          @template.hidden_field_tag("#{@object_name}[permitted_fields]", encoded_auto_permitted_attributes)
        end
      end

    end
  end
end
