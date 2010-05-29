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
end
