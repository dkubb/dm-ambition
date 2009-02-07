# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{dm-ambition}
  s.version = "0.10.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Dan Kubb"]
  s.date = %q{2009-02-07}
  s.description = %q{DataMapper plugin providing an Ambition-like API}
  s.email = ["dan.kubb [a] gmail [d] com"]
  s.extra_rdoc_files = ["README.txt", "LICENSE", "TODO", "History.txt"]
  s.files = [".gitignore", "History.txt", "LICENSE", "Manifest.txt", "README.txt", "Rakefile", "TODO", "dm-ambition.gemspec", "lib/dm-ambition.rb", "lib/dm-ambition/collection.rb", "lib/dm-ambition/model.rb", "lib/dm-ambition/query.rb", "lib/dm-ambition/query/filter_processor.rb", "lib/dm-ambition/version.rb", "spec/public/collection_spec.rb", "spec/public/model_spec.rb", "spec/semipublic/query_spec.rb", "spec/spec.opts", "spec/spec_helper.rb", "tasks/hoe.rb", "tasks/install.rb", "tasks/spec.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/dkubb/dm-ambition}
  s.rdoc_options = ["--main", "README.txt"]
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{dm-ambition}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{DataMapper plugin providing an Ambition-like API}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<dm-core>, ["= 0.10.0"])
    else
      s.add_dependency(%q<dm-core>, ["= 0.10.0"])
    end
  else
    s.add_dependency(%q<dm-core>, ["= 0.10.0"])
  end
end
