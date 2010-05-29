require 'dm-ambition/collection'
require 'dm-ambition/model'
require 'dm-ambition/query'
require 'dm-ambition/version'

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
      def new_collection(query, resources = nil, &block)
        collection = self.class.new(query, &block)

        if resources
          collection.replace(resources)
        end

        collection
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
