# Nifty Utils

This repository contains a number of useful utilties which are useful in most (if not all)
Rails applications.

We are just working to build this up and fully test & document the contents. All values should
be documented using RDoc syntax and can be output by running the command below from the root 
of the repository.

```
bundle exec sdoc
open doc/index.html
```

## The Nifty Key Value Store

If you want to create a quick key/value store in your application where the values relate to an
existing model, this is very helpful.

Firstly, you'll need to create the database table and then, once added, you can specify what objects
you want to store.

```
$ rails generate nifty:utils:key_value_store:migration
$ rake db:migrate
```

```ruby
class Person < ActiveRecord::Base
  key_value_store :settings
  key_value_store :other_settings
end

person = Person.new
person.settings             = {:colour => 'red', :fruit => 'apple'}
person.other_settings_json  = "{"hello":"world"}"
person.save

person = Person.find(person.id)
person.settings         #=> {'colour' => 'red', 'fruit' => 'apple'}
person.settings_json    #=> "{'color':'red', 'fruit':'apple'}"
```

A few points to note about this:

* All values are stored as strings in the database
* All keys are stored as strings and returned as strings in their hash
