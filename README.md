# dm-ambition

DataMapper::Ambition is a plugin that provides an Ambition-like API for
accessing DataMapper models.

## Installation

With Rubygems:

```bash
$ gem install veritas
$ irb -rubygems
>> require 'veritas'
=> true
```

With git and local working copy:

```bash
$ git clone git://github.com/dkubb/veritas.git
$ cd veritas
$ rake install
$ irb -rubygems
>> require 'veritas'
=> true
```

## Testing

The simplest way to test is with Bundler since it handles all dependencies:

```bash
$ rake local_gemfile
$ BUNDLE_GEMFILE="Gemfile.local" ADAPTER="in_memory" bundle install --without=quality --relock
$ BUNDLE_GEMFILE="Gemfile.local" ADAPTER="in_memory" bundle exec rake spec
```

## Examples

```ruby
# with == operator
User.select { |u| u.name == 'Dan Kubb' }

# with =~ operator
User.select { |u| u.name =~ /Dan Kubb/ }

# with > operator
User.select { |u| u.id > 1 }

# with >= operator
User.select { |u| u.id >= 1 }

# with < operator
User.select { |u| u.id < 1 }

# with <= operator
User.select { |u| u.id <= 1 }

# with < operator
User.select { |u| u.id < 1 }

# with receiver.attribute.nil?
User.select { |u| u.id.nil? }

# with nil bind value
User.select { |u| u.id == nil }

# with true bind value
User.select { |u| u.admin == true }

# with false bind value
User.select { |u| u.admin == false }

# with AND conditions
User.select { |u| u.id == 1 && u.name == 'Dan Kubb' }

# with negated conditions
User.select { |u| !(u.id == 1) }

# with double-negated conditions
User.select { |u| !(!(u.id == 1)) }

# with matching from receiver
User.select { |u| u == user }

# with matching to receiver
User.select { |u| user == u }

# using send on receiver
User.select { |u| u.send(:name) == 'Dan Kubb' }

# with Array#include?
User.select { |u| user_ids.include?(u.id) }

# with Range#include?
User.select { |u| (1..10).include?(u.id) }

# with Hash#key?
User.select { |u| { 1 => 'Dan Kubb' }.key?(u.id) }

# with Hash#value?
User.select { |u| { 'Dan Kubb' => 1 }.value?(u.id) }

# with receiver and Array#include?
User.select { |u| users.include?(u) }

# with receiver and Hash#key?
User.select { |u| { user => 'Dan Kubb' }.key?(u) }

# with receiver and Hash#value?
User.select { |u| { 'Dan Kubb' => user }.value?(u) }
```

## Copyright

Copyright &copy; 2009-2011 Dan Kubb. See LICENSE for details.
