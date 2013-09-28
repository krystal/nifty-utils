module Nifty
  module Utils
    module KeyValueStore
      module ModelExtension
  
        def self.included(base)
          base.extend ClassMethods
        end

        module ClassMethods
          def key_value_stores
            @key_value_stores ||= []
          end
    
          def key_value_store(*names)
            
            unless self.reflect_on_all_associations(:has_many).map(&:name).include?(:nifty_key_value_pairs)
              has_many :nifty_key_value_pairs, :as => :parent, :dependent => :destroy, :class_name => 'Nifty::Utils::KeyValueStore::KeyValuePair'
              after_save :save_custom_values_to_db
            end
            
            names.each do |name|
              key_value_stores << name
        
              # Getter
              define_method name do
                if value = instance_variable_get("@#{name}")
                  value
                else
                  instance_variable_set "@#{name}", get_custom_values_for(name)
                end
              end
        
              # JSON Getter
              define_method "#{name}_json" do
                send(name).to_json
              end
        
              # Setter
              define_method "#{name}=" do |value|
                instance_variable_set("@#{name}", value)
              end
        
              # JSON Setter
              define_method "#{name}_json=" do |value|
                send("#{name}=", JSON.parse(value))
              end
        
            end
          end
        end
  
        # Get the values for a given group as a hash from the database without caching
        def get_custom_values_for(group)
          nifty_key_value_pairs.where(:group => group).inject({}) do |hash, value|
            hash[value.name] = value.value
            hash
          end
        end
  
        # Save all custom values in the appropriate methods to the 
        def save_custom_values_to_db
          # get the existing joins ready
          existing_joins = self.nifty_key_value_pairs
          # go through all groups
          self.class.key_value_stores.each do |group|
            db_values     = get_custom_values_for(group)
            local_values  = self.send(group).delete_if { |k,v| v.blank? }
      
            # remove any keys which no longer exist
            keys_to_remove = db_values.keys - local_values.keys
            self.nifty_key_value_pairs.where(:group => group, :name => keys_to_remove).destroy_all unless keys_to_remove.empty?
      
            # add/update all remaining keys
            local_values.each do |key, value|
              if existing_join = existing_joins.select { |j| j.group == group.to_s && j.name == key}.first
                existing_join.value = value
                existing_join.save
              else
                self.nifty_key_value_pairs.create(:group => group, :name => key, :value => value)
              end
            end
          end
        end
  
      end
    end
  end
end
