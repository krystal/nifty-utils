module Nifty
  module Utils
    class Railtie < Rails::Railtie
      
      initializer 'nifty.utils.initialize' do

        # Load the Active Record extensions
        ActiveSupport.on_load(:active_record) do
          require 'nifty/utils/active_record'
          ::ActiveRecord::Base.send :include, Nifty::Utils::ActiveRecord
        end
        
        # load the Action View helpers
        ActiveSupport.on_load(:action_view) do
          require 'nifty/utils/view_helpers'
          ActionView::Base.send :include, Nifty::Utils::ViewHelpers
        end
        
      end
      
    end
  end
end
