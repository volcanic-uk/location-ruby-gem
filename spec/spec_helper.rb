# frozen_string_literal: true

require 'volcanic/location'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before do
    Volcanic::Location.configure do |configure|
      configure.domain_url = 'http://test.com'
      configure.authentication = 'api_key'
    end
  end
end
