dm-ambition
===========

DataMapper::Ambition is a plugin that provides an Ambition-like API for
accessing DataMapper models.

Installation
------------

From Gem:

    $ sudo gem install dkubb-dm-ambition -s http://gems.github.com

With a local working copy:

    $ git clone git://github.com/dkubb/dm-ambition.git
    $ rake package && sudo rake install

Examples
--------

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

License
-------

Copyright (c) 2009 Dan Kubb

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
