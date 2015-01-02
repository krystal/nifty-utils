# Nifty Utils

This repository contains a number of useful utilties which are useful in most (if not all)
Rails applications.

## Active Record

The following are things which you can do with Active Record when you have Nifty Utils
in your Rails application.

### String Inquries

These allow you to add inquiry methods for easily checking on the status of an object.

```ruby
class Application < ActiveRecord::Base
  STATUSES = ['approved', 'declined']
  inquirer :status, *STATUSES
end

application = Application.new(:status => 'approved')
application.approved?     #=> true
application.declined?     #=> false
```

### Random String Fields

These allow you to set random strings for any column in a model.

```ruby
class Person < ActiveRecord::Base
  random_string :token, :type => :hex, :length => 8
  random_string :reset_token, :type => :uuid, :unique => true
  random_string :password, :type => :chars, :length => 12, :symbols => false
end

person = Person.create
person.token              #=> '5b24bff492375bc3'
person.reset_token        #=> '5e5c9d29-0b07-4690-945c-394f00a0f436'
person.password           #=> 'I1yMlUzmaT3j'
```

* The `:unique` option can be used in any item. It will ensure that no other record
  exists with the same value when saving. It does not add a uniqueness validator so
  if a record is added with a manually entered value for the field it will not stop
  the addition of the new record.

* The value will only be set if the current value is blank.

### Default Values

This allows you to set the default value for any field.

```ruby
class BackupSchedule < ActiveRecord::Base
  default_value :application, -> { self.resource && self.resource.application }
  default_value :minute, -> { rand(58) + 1 }
  default_value :next_run_at, -> { Time.now }
end

bs  = BackupSchedule.create
bs.application            #=> <Application>
bs.minute                 #=> 15
bs.next_run_at            #=> 2015-01-02 18:39:25 +0000
```
