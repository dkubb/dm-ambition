require 'pathname'
require 'rubygems'

gem 'extlib', '~>0.9.11'
require 'extlib'

dir = Pathname(__FILE__).dirname.expand_path / 'dm-ambition'

require dir / 'version'

gem 'dm-core', DataMapper::Ambition::VERSION
require 'dm-core'

require dir / 'collection'
require dir / 'model'
require dir / 'query'

module DataMapper
  class Collection
    include Ambition::Collection
  end

  module Model
    include Ambition::Model
  end

  class Query
    include Ambition::Query
  end
end
