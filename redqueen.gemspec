# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'redqueen/version'

Gem::Specification.new do |spec|
  spec.name          = "redqueen"
  spec.version       = Redqueen::VERSION
  spec.authors       = ["Sudhir Jonathan"]
  spec.email         = ["sudhir.j@gmail.com"]
  spec.description   = %q{Rails wrapper for Redis}
  spec.summary       = %q{Rails wrapper for Redis}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "redis"
  spec.add_runtime_dependency "active_support"
  spec.add_runtime_dependency "msgpack"
  spec.add_runtime_dependency "i18n"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "guard-bundler"
end
