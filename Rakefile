require 'rubygems'
require 'rake'

require File.expand_path('../lib/dm-ambition/version', __FILE__)

begin
  gem 'jeweler', '~> 1.5.2'
  require 'jeweler'

  Jeweler::Tasks.new do |gem|
    gem.name        = 'dm-ambition'
    gem.summary     = 'DataMapper plugin providing an Ambition-like API'
    gem.description = gem.summary
    gem.email       = 'dan.kubb@gmail.com'
    gem.homepage    = 'http://github.com/dkubb/%s' % gem.name
    gem.authors     = [ 'Dan Kubb' ]
    gem.has_rdoc    = 'yard'

    gem.version = DataMapper::Ambition::VERSION

    gem.required_ruby_version = '~> 1.8.7'

    gem.rubyforge_project = 'dm-ambition'
  end

  Jeweler::GemcutterTasks.new

  FileList['tasks/**/*.rake'].each { |task| import task }
rescue LoadError
  puts 'Jeweler (or a dependency) not available. Install it with: gem install jeweler'
end
