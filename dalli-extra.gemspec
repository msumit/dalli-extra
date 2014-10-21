# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dalli/extra/version'

Gem::Specification.new do |spec|
  spec.name          = "dalli-extra"
  spec.version       = Dalli::Extra::VERSION
  spec.authors       = ["Sumit Maheshwari"]
  spec.email         = ["sumeet.manit@gmail.com"]
  spec.description   = 'Adding some extra methods to Dalli'
  spec.summary       = 'Adding some extra methods to Dalli'
  spec.homepage      = "https://github.com/msumit/dalli-extra"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_dependency "dalli", "~> 2.7"
end
