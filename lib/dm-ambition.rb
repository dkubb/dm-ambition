require 'dm-ambition/collection'
require 'dm-ambition/model'
require 'dm-ambition/query'
require 'dm-ambition/version'

module DataMapper
  [ :Collection, :Model, :Query ].each do |mod|
    const_get(mod).send(:include, Ambition.const_get(mod))
  end
end
