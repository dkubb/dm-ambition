source 'http://rubygems.org'

DATAMAPPER = 'git://github.com/datamapper'
DM_VERSION = '~> 1.0.2'

group :runtime do

  if ENV['EXTLIB']
    gem 'extlib', '~> 0.9.15', SOURCE => "#{DATAMAPPER}/extlib#{REPO_POSTFIX}", :require => nil
  else
    gem 'activesupport', '~> 3.0.4', :require => nil
    gem 'i18n',          '~> 0.5.0'
  end

  gem 'dm-core',   DM_VERSION, :git => "#{DATAMAPPER}/dm-core.git"
  gem 'ParseTree', '~> 3.0.7', :platforms => :mri_18
  gem 'ruby2ruby', '~> 1.2.5'

end

group :development do

  gem 'dm-migrations', DM_VERSION, :git => "#{DATAMAPPER}/dm-migrations.git"
  gem 'jeweler',       '~> 1.5.2'
  gem 'rake',          '~> 0.8.7'
  gem 'rspec',         '~> 1.3.1'

end

group :quality do

  gem 'metric_fu', '~> 1.3'
  gem 'rcov',      '~> 0.9.8'
  gem 'reek',      '~> 1.2.8'
  gem 'roodi',     '~> 2.1'
  gem 'yard',      '~> 0.5'
  gem 'yardstick', '~> 0.1'

end

group :datamapper do

  adapters = ENV['ADAPTER'] || ENV['ADAPTERS']
  adapters = adapters.to_s.tr(',', ' ').split.uniq - %w[ in_memory ]

  DO_VERSION     = '~> 0.10.2'
  DM_DO_ADAPTERS = %w[ sqlite postgres mysql oracle sqlserver ]

  if (do_adapters = DM_DO_ADAPTERS & adapters).any?
    options = {}
    options[:git] = "#{DATAMAPPER}/do.git" if ENV['DO_GIT'] == 'true'

    gem 'data_objects', DO_VERSION, options.dup

    do_adapters.each do |adapter|
      adapter = 'sqlite3' if adapter == 'sqlite'
      gem "do_#{adapter}", DO_VERSION, options.dup
    end

    gem 'dm-do-adapter', DM_VERSION, :git => "#{DATAMAPPER}/dm-do-adapter.git"
  end

  adapters.each do |adapter|
    gem "dm-#{adapter}-adapter", DM_VERSION, :git => "#{DATAMAPPER}/dm-#{adapter}-adapter.git"
  end

  plugins = ENV['PLUGINS'] || ENV['PLUGIN']
  plugins = plugins.to_s.tr(',', ' ').split.push('dm-migrations').uniq

  plugins.each do |plugin|
    gem plugin, DM_VERSION, :git => "#{DATAMAPPER}/#{plugin}.git"
  end

end
