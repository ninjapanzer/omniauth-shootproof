require 'faraday'
require 'logger'

module OmniAuth
  module Shootproof
    class Client < ::OAuth2::Client # rubocop:disable Metrics/ClassLength
      # Initializes an AccessToken by making a request to the token endpoint
      #
      # @param [Hash] params a Hash of params for the token endpoint
      # @param [Hash] access token options, to pass to the AccessToken object
      # @param [Class] class of access token for easier subclassing OAuth2::AccessToken
      # @return [AccessToken] the initalized AccessToken
      def get_token(params, access_token_opts = {}, access_token_class = ::OAuth2::AccessToken) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
        params = ::OAuth2::Authenticator.new(id, secret, options[:auth_scheme]).apply(params)
        opts = {:raise_errors => options[:raise_errors], :parse => params.delete(:parse)}
        headers = params.delete(:headers) || {}
        if options[:token_method] == :post
          opts[:params] = params
          opts[:params].merge!(redirection_params)
          opts[:headers] = {'Content-Type' => 'application/x-www-form-urlencoded'}
        else
          error = Error.new('Must Be POST')
          raise(error)
        end
        opts[:headers].merge!(headers)
        response = request(options[:token_method], token_url, opts)
        if options[:raise_errors] && !(response.parsed.is_a?(Hash) && response.parsed['access_token'])
          error = Error.new(response)
          raise(error)
        end
        access_token_class.from_hash(self, response.parsed.merge(access_token_opts))
      end

      # The redirect_uri parameters, if configured
      #
      # The redirect_uri query parameter is OPTIONAL (though encouraged) when
      # requesting authorization. If it is provided at authorization time it MUST
      # also be provided with the token exchange request.
      #
      # Providing the :redirect_uri to the OAuth2::Client instantiation will take
      # care of managing this.
      #
      # @api semipublic
      #
      # @see https://tools.ietf.org/html/rfc6749#section-4.1
      # @see https://tools.ietf.org/html/rfc6749#section-4.1.3
      # @see https://tools.ietf.org/html/rfc6749#section-4.2.1
      # @see https://tools.ietf.org/html/rfc6749#section-10.6
      # @return [Hash] the params to add to a request or URL
      def redirection_params
        if options[:redirect_uri]
          {:redirect_uri => options[:redirect_uri]}
        else
          {}
        end
      end
    end
  end
end
