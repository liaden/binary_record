# BinaryRecord

Useful for specifying a class that can be serialized for network IO as well as saved to the database with all the functionality of active record.

## Installation

Add this line to your application's Gemfile:

    gem 'binary_record'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install binary_record

## Usage

To serialize:
``` ruby
class Message < ActiveRecord::Base
  acts_as_serializable
  
  endian :big # or :little
  
  # order of validates_binary specifies the order of fields for the binary string
  
  # validates range
  validates_binary :field, :int16
  
  # adds after_initialize callback to set constant_field to 5
  # adds validator to check the value is indeed 5
  validates_binary :constant_field, :uint8, :value => 5
end

# writes out binary string
Message.new(:field => 3).to_binary_s

# returns null because message is not valid
Message.new(:field => 1000000000).to_binary_s

# throws exception because message is not valid
Message.new(:field => 1000000000).to_binary_s!

# parse binary string into a new instance of message
Message.read(binary_string) 

# parse binary string into this instance of message
message = Message.new
message.read(binary_string)
```
