# Nifty Utils

This repository contains a number of useful utilties which are useful in most (if not all)
Rails applications.

## View Helpers

#### Displaying flash messages

This method will return HTML containing any flash messages in the types provided.

```ruby
display_flash                             # => Will show messages for alert, warning & notices only
display_flash(:types => [:custom_name])   # => Will show messages for custom_name only
```

The HTML generated will look like this:

```html
<p class='flashMessage flashMessage--notice' id='flash-notice'>
  Your message here.
</p>
```

#### Generating Twitter Share URLs

```ruby
twitter_share_url(:text => 'Some text to tweet', :url => 'http://yourapp.com/blah')
```

#### Length of time in words

```ruby
length_of_time_in_words(60)         #=> "1 minute"
length_of_time_in_words(65)         #=> "1 minute, 5 seconds"
```

#### Other methods

* `rfc4226_qrcode(token)`
* `gravatar(email, options = {})`
* `boolean_tag(bool)`

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

## Other Utilities

### Until with maximum attempts

Until blocks are great but can result in infinate loops which may be undesirable
in certain situations. This helper method allows you to run an until block
with a maximum number of attempts.

Here's an example of how this might be used. We will check the job 5 times with
a 2 second gap between.


```ruby
require 'nifty/utils/until_with_max_attempts'

begin
  Nifty::Utils::UntilWithMaxAttempts.until proc { job.complete? }, :attempts => 5, :gap => 2 do
    puts "Waiting for job to complete..."
  end
  puts "Job has completed successfully!"
rescue Nifty::Utils::UntilWithMaxAttempts::MaxAttemptsReached
  puts "Job did not complete in a timely manner."
  exit 1
end
```

If you include the extensions provided by this library, you can also call this
using the `until_with_max_attempts` method which is added to the Object class.

### Auto Attribute Permitting

To permit attribtues to be bulk assigned, we often see `params.permit(:field1, :field2)`
in our controllers. This automatic method will permit the fields which are included
in the form to be saved in a secure manner.

```ruby
# In an initializer
require 'nifty/utils/auto_attribute_permit'
Nifty::Utils::AutoAttributePermit.setup

# In your controllers
params.require(:person).permit(:auto)
```

Note: only fields which have labels which are present in the form before the submit
button will be auto permitted.
