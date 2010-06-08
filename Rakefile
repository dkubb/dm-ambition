require 'rubygems'
require 'rake'

require File.expand_path('../lib/dm-ambition/version', __FILE__)

begin
  gem 'jeweler', '~> 1.4'
  require 'jeweler'

  Jeweler::Tasks.new do |gem|
    gem.name        = 'dm-ambition'
    gem.summary     = 'DataMapper plugin providing an Ambition-like API'
    gem.description = gem.summary
    gem.email       = 'dan.kubb@gmail.com'
    gem.homepage    = 'http://github.com/dkubb/%s' % gem.name
    gem.authors     = [ 'Dan Kubb' ]

    gem.version = DataMapper::Ambition::VERSION

    gem.required_ruby_version = '~> 1.8.6'

    gem.rubyforge_project = 'dm-ambition'

    gem.add_dependency 'dm-core',   '~> 1.0.0'
    gem.add_dependency 'ParseTree', '~> 3.0.5'
    gem.add_dependency 'ruby2ruby', '~> 1.2.4'

    gem.add_development_dependency 'dm-migrations', '~> 1.0.0'
    gem.add_development_dependency 'rspec',         '~> 1.3'
  end

  Jeweler::GemcutterTasks.new

  FileList['tasks/**/*.rake'].each { |task| import task }
rescue LoadError
  puts 'Jeweler (or a dependency) not available. Install it with: gem install jeweler'
end
