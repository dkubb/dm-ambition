# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{dm-ambition}
  s.version = "1.1.0.rc1"

  s.required_rubygems_version = Gem::Requirement.new("> 1.3.1") if s.respond_to? :required_rubygems_version=
  s.authors = ["Dan Kubb"]
  s.date = %q{2011-02-28}
  s.description = %q{DataMapper plugin providing an Ambition-like API}
  s.email = %q{dan.kubb@gmail.com}
  s.extra_rdoc_files = [
    "LICENSE",
    "README.rdoc",
    "TODO"
  ]
  s.files = [
    ".document",
    "Gemfile",
    "LICENSE",
    "Manifest.txt",
    "README.rdoc",
    "Rakefile",
    "TODO",
    "dm-ambition.gemspec",
    "lib/dm-ambition.rb",
    "lib/dm-ambition/collection.rb",
    "lib/dm-ambition/model.rb",
    "lib/dm-ambition/query.rb",
    "lib/dm-ambition/query/filter_processor.rb",
    "lib/dm-ambition/version.rb",
    "spec/public/collection_spec.rb",
    "spec/public/model_spec.rb",
    "spec/public/shared/filter_shared_spec.rb",
    "spec/rcov.opts",
    "spec/semipublic/query_spec.rb",
    "spec/spec.opts",
    "spec/spec_helper.rb",
    "tasks/ci.rake",
    "tasks/clean.rake",
    "tasks/heckle.rake",
    "tasks/local_gemfile.rake",
    "tasks/metrics.rake",
    "tasks/spec.rake",
    "tasks/yard.rake",
    "tasks/yardstick.rake"
  ]
  s.homepage = %q{http://github.com/dkubb/dm-ambition}
  s.require_paths = ["lib"]
  s.required_ruby_version = Gem::Requirement.new("~> 1.8.7")
  s.rubyforge_project = %q{dm-ambition}
  s.rubygems_version = %q{1.5.2}
  s.summary = %q{DataMapper plugin providing an Ambition-like API}
  s.test_files = [
    "spec/public/collection_spec.rb",
    "spec/public/model_spec.rb",
    "spec/public/shared/filter_shared_spec.rb",
    "spec/semipublic/query_spec.rb",
    "spec/spec_helper.rb"
  ]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activesupport>, ["~> 3.0.4"])
      s.add_runtime_dependency(%q<i18n>, ["~> 0.5.0"])
      s.add_runtime_dependency(%q<dm-core>, ["~> 1.0.2"])
      s.add_runtime_dependency(%q<ParseTree>, ["~> 3.0.7"])
      s.add_runtime_dependency(%q<ruby2ruby>, ["~> 1.2.5"])
      s.add_runtime_dependency(%q<sourcify>, ["~> 0.4.2"])
      s.add_development_dependency(%q<dm-migrations>, ["~> 1.0.2"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.5.2"])
      s.add_development_dependency(%q<rake>, ["~> 0.8.7"])
      s.add_development_dependency(%q<rspec>, ["~> 1.3.1"])
    else
      s.add_dependency(%q<activesupport>, ["~> 3.0.4"])
      s.add_dependency(%q<i18n>, ["~> 0.5.0"])
      s.add_dependency(%q<dm-core>, ["~> 1.0.2"])
      s.add_dependency(%q<ParseTree>, ["~> 3.0.7"])
      s.add_dependency(%q<ruby2ruby>, ["~> 1.2.5"])
      s.add_dependency(%q<sourcify>, ["~> 0.4.2"])
      s.add_dependency(%q<dm-migrations>, ["~> 1.0.2"])
      s.add_dependency(%q<jeweler>, ["~> 1.5.2"])
      s.add_dependency(%q<rake>, ["~> 0.8.7"])
      s.add_dependency(%q<rspec>, ["~> 1.3.1"])
    end
  else
    s.add_dependency(%q<activesupport>, ["~> 3.0.4"])
    s.add_dependency(%q<i18n>, ["~> 0.5.0"])
    s.add_dependency(%q<dm-core>, ["~> 1.0.2"])
    s.add_dependency(%q<ParseTree>, ["~> 3.0.7"])
    s.add_dependency(%q<ruby2ruby>, ["~> 1.2.5"])
    s.add_dependency(%q<sourcify>, ["~> 0.4.2"])
    s.add_dependency(%q<dm-migrations>, ["~> 1.0.2"])
    s.add_dependency(%q<jeweler>, ["~> 1.5.2"])
    s.add_dependency(%q<rake>, ["~> 0.8.7"])
    s.add_dependency(%q<rspec>, ["~> 1.3.1"])
  end
end

