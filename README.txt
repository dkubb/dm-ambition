dm-ambition
===========

DataMapper plugin providing an Ambition-like API

Examples
========

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

# with receiver matching
User.select { |u| u == user }

# using send on receiver
User.select { |u| u.send(:name) == 'Dan Kubb' }
