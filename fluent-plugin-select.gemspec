# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "fluent-plugin-select"
  s.version     = "0.0.3.1"
  s.authors     = ["Kohei Tomita"]
  s.email       = ["tommy.fmale@gmail.com"]
  s.homepage    = "https://github.com/tomity/fluent-plugin-select"
  s.summary     = %q{fluent-plugin-select is the non-buffered plugin that can be filtered by ruby script. }
  s.description = %q{fluent-plugin-select is the non-buffered plugin that can be filtered by ruby script. }

  s.rubyforge_project = "fluent-plugin-select"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "rake", "~> 0.9.2.2"
  s.add_development_dependency "fluentd", "~> 0.10.24"
end
