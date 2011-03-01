require 'dm-core'
require 'sourcify'
require 'ruby2ruby'

require 'dm-ambition/collection'
require 'dm-ambition/model'

require 'dm-ambition/query'
require 'dm-ambition/query/filter_processor'

require 'dm-ambition/version'

module DataMapper
  %w[ Collection Model Query ].each do |mod|
    const_get(mod).class_eval { include Ambition.const_get(mod) }
  end
end
