# frozen_string_literal: true

require_relative "lib/volcanic/location/version"

Gem::Specification.new do |spec|
  spec.name          = "volcanic-location"
  spec.version       = Volcanic::Location::VERSION
  spec.authors       = ["Volcanic UK"]
  spec.email         = [""]

  spec.summary       = "A gem for interacting with the Volcanic locations service"
  spec.description   = spec.summary
  spec.homepage      = "https://github.com/volcanic-uk/location-ruby-gem"
  spec.required_ruby_version = ">= 2.7"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "activesupport", "~> 6.0.3.7"
  spec.add_dependency "faraday", "~> 1.10.3"
  spec.add_dependency "faraday_middleware", "~> 1.0"

  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rubocop", "~> 0.80"
end
