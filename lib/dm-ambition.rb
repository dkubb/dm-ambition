require 'pathname'
require 'rubygems'

dir = Pathname(__FILE__).dirname.expand_path + 'dm-ambition'

require dir + 'version'

#gem 'dm-core', DataMapper::Ambition::VERSION
require 'dm-core'
require 'dm-core/version'

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

  if Gem::Version.new(DataMapper::VERSION) < Gem::Version.new('0.10')
    module Model
      def self.descendants
        Resource.descendants
      end
    end

    class Collection
      def new_collection(query, resources)
        self.class.new(query).replace(resources)
      end
    end

    module Resource
      def saved?
        !new_record?
      end

      alias new? new_record?
    end
  end
end
