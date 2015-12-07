# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'exceptor/version'

Gem::Specification.new do |spec|
  spec.name          = "exceptor"
  spec.version       = Exceptor::VERSION
  spec.authors       = ["Ehsan Yousefi"]
  spec.email         = ["ehsan.yousefi@live.com"]

  spec.summary       = %q{Handle your exceptions with an elegant OO pattern.}
  spec.description   = %q{With Exceptor handle all of your exceptions in one place, Don't repeat yourself! define a handler for your exception and use it all over the program.}
  spec.homepage      = "https://github.com/EhsanYousefi/Exceptor"
  spec.license       = "MIT"


  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
end
