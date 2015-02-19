module Nifty
  module Utils
    class Railtie < Rails::Railtie #:nodoc:

      initializer 'nifty.utils.initialize' do |app|
        Rails.application.config.i18n.load_path << File.expand_path(File.join('..', '..', '..', '..', 'locales', 'en.yml'), __FILE__)

        # Load the Active Record extensions
        ActiveSupport.on_load(:active_record) do
          require 'nifty/utils/active_record/inquirer'
          ::ActiveRecord::Base.send :include, Nifty::Utils::ActiveRecord::Inquirer
          require 'nifty/utils/active_record/random_string'
          ::ActiveRecord::Base.send :include, Nifty::Utils::ActiveRecord::RandomString
          require 'nifty/utils/active_record/default_value'
          ::ActiveRecord::Base.send :include, Nifty::Utils::ActiveRecord::DefaultValue
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
