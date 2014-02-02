# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'binary_record/version'

Gem::Specification.new do |spec|
  spec.name          = "binary_record"
  spec.version       = BinaryRecord::VERSION
  spec.authors       = ["Joel Johnson"]
  spec.email         = ["johnson.joel.b@gmail.com"]
  spec.description   = %q{Extend active record using bindata so that database records can be serialized}
  spec.summary       = %q{TODO: Write a gem summary}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = Dir['*/**']
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "sqlite3"
  
  spec.add_dependency "activerecord", "~> 3.2"
  spec.add_dependency "bindata", "~>1.4"
end
