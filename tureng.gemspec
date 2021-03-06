# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tureng/version'

Gem::Specification.new do |spec|
  spec.name          = "tureng"
  spec.version       = Tureng::VERSION
  spec.authors       = ["Uğur Özyılmazel"]
  spec.email         = ["ugurozyilmazel@gmail.com"]
  spec.summary       = %q{Unofficial Tureng dictionary tool.}
  spec.description   = %q{Turkish-English dictionary tool for commandline.}
  spec.homepage      = "https://github.com/vigo/tureng"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  
  spec.add_runtime_dependency "nokogiri"
  spec.add_runtime_dependency "text-table"
  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest"
end
