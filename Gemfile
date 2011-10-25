source :rubygems

SOURCE         = ENV.fetch('SOURCE', :git).to_sym
REPO_POSTFIX   = SOURCE == :path ? ''                                : '.git'
DATAMAPPER     = SOURCE == :path ? Pathname(__FILE__).dirname.parent : 'http://github.com/datamapper'
DM_VERSION     = '~> 1.3.0.beta'
DO_VERSION     = '~> 0.10.6'
DM_DO_ADAPTERS = %w[ sqlite postgres mysql oracle sqlserver ]

gem 'dm-core',   DM_VERSION, SOURCE => "#{DATAMAPPER}/dm-core#{REPO_POSTFIX}"
gem 'ParseTree', '~> 3.0.7', :platforms => :mri_18
gem 'ruby2ruby', '~> 1.2.5'
gem 'sourcify',  '~> 0.5.0'

group :development do
  gem 'jeweler', '~> 1.6.4'
  gem 'rake',    '~> 0.9.2'
  gem 'rspec',   '~> 1.3.2'
  gem 'yard',    '~> 0.7.2'
end

group :guard do
  gem 'guard',         '~> 0.7.0'
  gem 'guard-bundler', '~> 0.1.3'
  gem 'guard-rspec',   '~> 0.4.5'
end

platforms :mri_18 do
  group :metrics do
    gem 'arrayfields', '~> 4.7.4'
    gem 'fattr',       '~> 2.2.0'
    gem 'flay',        '~> 1.4.2'
    gem 'flog',        '~> 2.5.3'
    gem 'heckle',      '~> 1.4.3'
    gem 'json',        '~> 1.6.1'
    gem 'map',         '~> 4.4.0'
    gem 'metric_fu',   '~> 2.1.1'
    gem 'mspec',       '~> 1.5.17'
    gem 'rcov',        '~> 0.9.9'
    gem 'reek',        '~> 1.2.8', :git => 'git://github.com/dkubb/reek.git'
    gem 'roodi',       '~> 2.1.0'
    gem 'yardstick',   '~> 0.4.0'
  end
end

group :datamapper do
  adapters = ENV['ADAPTER'] || ENV['ADAPTERS']
  adapters = adapters.to_s.tr(',', ' ').split.uniq - %w[ in_memory ]

  if (do_adapters = DM_DO_ADAPTERS & adapters).any?
    do_options = {}
    do_options[:git] = "#{DATAMAPPER}/do#{REPO_POSTFIX}" if ENV['DO_GIT'] == 'true'

    gem 'data_objects', DO_VERSION, do_options.dup

    do_adapters.each do |adapter|
      adapter = 'sqlite3' if adapter == 'sqlite'
      gem "do_#{adapter}", DO_VERSION, do_options.dup
    end

    gem 'dm-do-adapter', DM_VERSION, SOURCE => "#{DATAMAPPER}/dm-do-adapter#{REPO_POSTFIX}"
  end

  adapters.each do |adapter|
    gem "dm-#{adapter}-adapter", DM_VERSION, SOURCE => "#{DATAMAPPER}/dm-#{adapter}-adapter#{REPO_POSTFIX}"
  end

  plugins = ENV['PLUGINS'] || ENV['PLUGIN']
  plugins = plugins.to_s.tr(',', ' ').split.push('dm-migrations').uniq

  plugins.each do |plugin|
    gem plugin, DM_VERSION, SOURCE => "#{DATAMAPPER}/#{plugin}#{REPO_POSTFIX}"
  end
end
