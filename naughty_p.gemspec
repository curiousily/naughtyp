# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "naughty_p/version"

Gem::Specification.new do |s|
  s.name = "naughty_p"
  s.version = NaughtyP::VERSION
  s.authors = ["Venelin Valkov"]
  s.email = ["venelin@naughtyspirit.com"]
  s.homepage = ""
  s.summary = %q{Simple Pascal-like programming language}
  s.description = %q{Simple Pascal-like programming language compiler. University project}

  s.rubyforge_project = "naughty_p"

  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
  s.add_dependency "ruby_events", "~> 1.1.0"
  s.add_dependency "bitescript", "~> 0.1.0"
end
