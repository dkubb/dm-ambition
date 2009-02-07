require 'pathname'
require 'rubygems'

SPEC_ROOT = Pathname(__FILE__).dirname.expand_path
require SPEC_ROOT.parent + 'lib/dm-ambition'
Pathname.glob((SPEC_ROOT + '{lib,*/shared}/**/*.rb').to_s).each { |f| require f }

def load_driver(name, default_uri)
  return false if ENV['ADAPTER'] != name.to_s

  begin
    DataMapper.setup(name, ENV["#{name.to_s.upcase}_SPEC_URI"] || default_uri)
    DataMapper::Repository.adapters[:default] = DataMapper::Repository.adapters[name]
    true
  rescue LoadError => e
    warn "Could not load do_#{name}: #{e}"
    false
  end
end

ENV['ADAPTER'] ||= 'sqlite3'

HAS_SQLITE3  = load_driver(:sqlite3,  'sqlite3::memory:')
HAS_MYSQL    = load_driver(:mysql,    'mysql://localhost/dm_core_test')
HAS_POSTGRES = load_driver(:postgres, 'postgres://postgres@localhost/dm_core_test')

Spec::Runner.configure do |config|
  config.after(:all) do
    # clear out models
    descendants = DataMapper::Model.descendants.dup.to_a
    while model = descendants.shift
      descendants.concat(model.descendants) if model.respond_to?(:descendants)
      Object.send(:remove_const, model.name.to_sym)
      DataMapper::Model.descendants.delete(model)
    end
  end
end
