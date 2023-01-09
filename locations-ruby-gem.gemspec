# frozen_string_literal: true

require_relative "lib/location/gem/version"

Gem::Specification.new do |spec|
  spec.name          = "locations-ruby-gem"
  spec.version       = Location::Gem::VERSION
  spec.authors       = ["Volcanic UK"]
  spec.email         = [""]

  spec.summary       = "A gem for interacting with the Volcanic locations service"
  spec.description   = spec.summary
  spec.homepage      = "https://github.com/volcanic-uk/location-ruby-gem"
  spec.required_ruby_version = ">= 2.3"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end
