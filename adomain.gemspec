
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "adomain/version"

Gem::Specification.new do |spec|
  spec.name          = "adomain"
  spec.version       = Adomain::VERSION
  spec.authors       = ["Sam Nissen"]
  spec.email         = ["scnissen@gmail.com"]

  spec.summary       = %q{Simple, uncomplicated, schemed domain parsing using Addressable}
  spec.homepage      = "https://github.com/samnissen/adomain"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"

  spec.add_dependency "addressable", "~> 2.5"
  spec.add_dependency "logger"
end
