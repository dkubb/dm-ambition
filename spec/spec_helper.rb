require 'dm-ambition'

require 'dm-core/spec/setup'
require 'dm-core/spec/lib/adapter_helpers'
require 'dm-core/spec/lib/spec_helper'

Dir['spec/*/shared/**/*.rb'].each { |file| require file }

Spec::Runner.configure do |config|

  config.extend(DataMapper::Spec::Adapters::Helpers)

  config.after :all do
    DataMapper::Spec.cleanup_models
  end

end
