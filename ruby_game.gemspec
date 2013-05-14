# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ruby_game/version'

Gem::Specification.new do |spec|
  spec.name          = "ruby_game"
  spec.version       = RubyGame::VERSION
  spec.authors       = ["DrBenton"]
  spec.email         = ["olivier@dr-benton.com"]
  spec.description   = %q{Un super jeu, à n'en pas douter, il est vraiment trop top, 95/100 sur Metacritic !}
  spec.summary       = %q{Un super jeu, à n'en pas douter}
  spec.homepage      = "https://github.com/DrBenton"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "gosu"
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
