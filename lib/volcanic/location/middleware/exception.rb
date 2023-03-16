# frozen_string_literal: true

require_relative 'middleware'
require_relative 'helper'

module Volcanic::Location::Middleware
  # Exception
  class Exception
    include Helper

    def initialize(app = nil)
      @app = app
    end

    def call(env)
      @app.call(env).on_complete do |response|
        status_code = response[:status].to_i
        body = resolve_body(response[:body])
        case status_code
        when 400..410
          error = build_standard_error(body)
          exception = resolve_exception(error[:error_code], status_code, env)
          raise(exception || Volcanic::Location::LocationError, error.to_json)
        when 500
          raise Volcanic::Location::ServerError, build_server_error(body)
        end
      end
    end

    private

    def resolve_exception(_error_code, status_code, _env)
      case status_code
      when 403
        Volcanic::Location::Forbidden
      when 404
        Volcanic::Location::LocationNotFound
      end
    end

    def build_standard_error(body)
      error = {
        request_id: body.delete('request_id'),
        message: body.delete('message'),
        reason: body.delete('reason'),
        status_code: body.delete('httpStatusCode'),
        error_code: body.delete('errorCode')
      }.compact

      error.empty? ? body : error
    end

    def build_server_error(body)
      {
        request_id: body.delete('request_id'),
        message: 'Server error, Please contact Location service support/team',
        status_code: 500
      }
    end

    def resolve_body(body)
      JSON.parse(body)
    rescue JSON::ParserError
      {}
    end
  end
end
