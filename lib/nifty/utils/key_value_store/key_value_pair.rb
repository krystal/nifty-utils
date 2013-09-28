# == Schema Information
#
# Table name: nifty_key_value_pairs
#
#  id          :integer          not null, primary key
#  parent_id   :integer
#  parent_type :string(255)
#  group       :string(255)
#  name        :string(255)
#  value       :string(255)
#
module Nifty
  module Utils
    module KeyValueStore
      
      class KeyValuePair < ::ActiveRecord::Base
        self.table_name = 'nifty_key_value_store'
        belongs_to :parent, :polymorphic => true
      end
      
    end
  end
end
