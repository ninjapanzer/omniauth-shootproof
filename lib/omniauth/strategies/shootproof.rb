require 'omniauth-oauth2'

module OmniAuth
  module Strategies
    class Shootproof < OmniAuth::Strategies::OAuth2

      # Give your strategy a name.
      option :name, 'shootproof'
      option :scope, 'sp.event.get_list sp.event.get_photos sp.photo.info'
      option :provider_ignores_state, true

      option :client_options, {
        site: 'https://auth.shootproof.com',
        authorize_url: '/oauth2/authorization/new',
        token_url: '/oauth2/authorization/token',
        token_method: :post
      }

      option :authorize_options, [:scope, :state, :code]
      option :token_options,     [:scope, :state, :code]

      # These are called after authentication has succeeded. If
      # possible, you should try to set the UID without making
      # additional calls (if the user id is returned with the token
      # or as a URI parameter). This may not be possible with all
      # providers.
      uid{ raw_info[:token] }

      info do
        {
          token: raw_info[:token],
          refresh_token: raw_info[:refresh_token],
          expires_at: raw_info[:expires_at],
          expires_in: raw_info[:expires_in]
        }
      end

      extra do
        {
          'raw_info' => raw_info
        }
      end

      def raw_info
        @raw_info ||= {
          token:         access_token.token,
          refresh_token: access_token.refresh_token,
          expires_at: access_token.expires_at,
          expires_in: access_token.expires_in
        }
      end

    protected
      def client
        OmniAuth::Shootproof::Client.new(options.client_id, options.client_secret, deep_symbolize(options.client_options))
      end

      def callback_url
        full_host + script_name + callback_path
      end

      # Initializes an AccessToken by making a request to the token endpoint
      #
      # @param [Hash] params a Hash of params for the token endpoint
      # @param [Hash] access token options, to pass to the AccessToken object
      # @param [Class] class of access token for easier subclassing OAuth2::AccessToken
      # @return [AccessToken] the initalized AccessToken
      def get_token(params, access_token_opts = {}, access_token_class = ::OAuth2::AccessToken) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
        params = Authenticator.new(id, secret, options[:auth_scheme]).apply(params)
        opts = {:raise_errors => options[:raise_errors], :parse => params.delete(:parse)}
        headers = params.delete(:headers) || {}
        opts[:params] = params
        opts[:params].merge!(redirection_params)
        opts[:headers] = {'Content-Type' => 'application/x-www-form-urlencoded'}
        opts[:headers].merge!(headers)
        response = request(options[:token_method], token_url, opts)
        if options[:raise_errors] && !(response.parsed.is_a?(Hash) && response.parsed['access_token'])
          error = Error.new(response)
          raise(error)
        end
        access_token_class.from_hash(self, response.parsed.merge(access_token_opts))
      end
    end
  end
end
