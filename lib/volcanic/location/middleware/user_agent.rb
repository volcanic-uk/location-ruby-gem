# frozen_string_literal: true

require_relative '../version'
require_relative 'middleware'

module Volcanic::Location::Middleware
  # middleware for user agent header
  class UserAgent
    def initialize(app = nil)
      @app = app
      @user_agent = "Location-ruby-gem v#{Volcanic::Location::VERSION}"
    end

    def call(request_env)
      request_env[:request_headers]['user-agent'] = @user_agent

      @app.call(request_env)
    end
  end
end
