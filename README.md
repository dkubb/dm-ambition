# dm-ambition

DataMapper::Ambition is a plugin that provides an Ambition-like API for
accessing DataMapper models.

[![Build Status](https://secure.travis-ci.org/dkubb/dm-ambition.png)](http://travis-ci.org/dkubb/dm-ambition)

## Installation

With Rubygems:

```bash
$ gem install dm-ambition
$ irb -rubygems
>> require 'dm-ambition'
=> true
```

With git and local working copy:

```bash
$ git clone git://github.com/dkubb/dm-ambition.git
$ cd dm-ambition
$ rake install
$ irb -rubygems
>> require 'dm-ambition'
=> true
```

## Testing

The simplest way to test is with Bundler since it handles all dependencies:

```bash
$ rake local_gemfile
$ BUNDLE_GEMFILE="Gemfile.local" sh -c "bundle && bundle exec rake spec"
```

## Examples

The standard Enumerable methods `select`, `detect`, `reject`, `find_all`, and
`find` may be used with dm-ambition. These methods may be applied to the Model
or Collection object.

```ruby
# with == operator
model_or_collection.select { |u| u.name == 'Dan Kubb' }

# with =~ operator
model_or_collection.select { |u| u.name =~ /Dan Kubb/ }

# with > operator
model_or_collection.select { |u| u.id > 1 }

# with >= operator
model_or_collection.select { |u| u.id >= 1 }

# with < operator
model_or_collection.select { |u| u.id < 1 }

# with <= operator
model_or_collection.select { |u| u.id <= 1 }

# with < operator
model_or_collection.select { |u| u.id < 1 }

# with receiver.attribute.nil?
model_or_collection.select { |u| u.id.nil? }

# with nil bind value
model_or_collection.select { |u| u.id == nil }

# with true bind value
model_or_collection.select { |u| u.admin == true }

# with false bind value
model_or_collection.select { |u| u.admin == false }

# with AND conditions
model_or_collection.select { |u| u.id == 1 && u.name == 'Dan Kubb' }

# with negated conditions
model_or_collection.select { |u| !(u.id == 1) }

# with double-negated conditions
model_or_collection.select { |u| !(!(u.id == 1)) }

# with matching from receiver
model_or_collection.select { |u| u == user }

# with matching to receiver
model_or_collection.select { |u| user == u }

# using send on receiver
model_or_collection.select { |u| u.send(:name) == 'Dan Kubb' }

# with Array#include?
model_or_collection.select { |u| user_ids.include?(u.id) }

# with Range#include?
model_or_collection.select { |u| (1..10).include?(u.id) }

# with Hash#key?
model_or_collection.select { |u| { 1 => 'Dan Kubb' }.key?(u.id) }

# with Hash#value?
model_or_collection.select { |u| { 'Dan Kubb' => 1 }.value?(u.id) }

# with receiver and Array#include?
model_or_collection.select { |u| users.include?(u) }

# with receiver and Hash#key?
model_or_collection.select { |u| { user => 'Dan Kubb' }.key?(u) }

# with receiver and Hash#value?
model_or_collection.select { |u| { 'Dan Kubb' => user }.value?(u) }
```

## Copyright

Copyright &copy; 2009-2011 Dan Kubb. See LICENSE for details.
