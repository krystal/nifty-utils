module Nifty
  module Utils
    class Railtie < Rails::Railtie #:nodoc:
      
      initializer 'nifty.utils.initialize' do

        # Load the Active Record extensions
        ActiveSupport.on_load(:active_record) do
          require 'nifty/utils/active_record'
          ::ActiveRecord::Base.send :include, Nifty::Utils::ActiveRecord
          
          require 'nifty/utils/key_value_store/key_value_pair'
          require 'nifty/utils/key_value_store/model_extension'
          ::ActiveRecord::Base.send :include, Nifty::Utils::KeyValueStore::ModelExtension
        end
        
        # load the Action View helpers
        ActiveSupport.on_load(:action_view) do
          require 'nifty/utils/view_helpers'
          ActionView::Base.send :include, Nifty::Utils::ViewHelpers
        end
        
      end
      
      generators do
        require 'nifty/utils/key_value_store/migration_generator'
      end
      
    end
  end
end
