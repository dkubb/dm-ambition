require 'pathname'
require 'rubygems'

ROOT    = Pathname(__FILE__).dirname.expand_path
JRUBY   = RUBY_PLATFORM =~ /java/
WINDOWS = Gem.win_platform?
SUDO    = (WINDOWS || JRUBY) ? '' : ('sudo' unless ENV['SUDOLESS'])

require ROOT + 'lib/dm-ambition/version'

AUTHOR           = 'Dan Kubb'
EMAIL            = 'dan.kubb [a] gmail [d] com'
GEM_NAME         = 'dm-ambition'
GEM_VERSION      = DataMapper::Ambition::VERSION
GEM_DEPENDENCIES = [
  [ 'dm-core',   GEM_VERSION ],
  [ 'ParseTree', '~>3.0.3'   ],
  [ 'ruby2ruby', '~>1.2.2'   ],
]

GEM_CLEAN  = %w[ log pkg coverage ]
GEM_EXTRAS = { :has_rdoc => true, :extra_rdoc_files => %w[ README.txt LICENSE TODO History.txt ] }

PROJECT_NAME        = 'dm-ambition'
PROJECT_URL         = "http://github.com/dkubb/#{GEM_NAME}"
PROJECT_DESCRIPTION = PROJECT_SUMMARY = 'DataMapper plugin providing an Ambition-like API'

#[ ROOT, ROOT.parent ].each do |dir|
[ ROOT ].each do |dir|
  Pathname.glob(dir.join('tasks/**/*.rb').to_s).each { |f| require f }
end
