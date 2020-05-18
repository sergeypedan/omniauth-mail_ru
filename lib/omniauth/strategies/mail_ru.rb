require "omniauth/strategies/oauth2"

require_relative "../user_info_fetcher"

module OmniAuth
  module Strategies

    # @example Basic Usage
    #   use OmniAuth::Strategies::MailRu, "API Key", "Secret Key"
    #
    class MailRu < OmniAuth::Strategies::OAuth2
      class NoAuthorizationCodeError < StandardError; end

      DEFAULT_SCOPE = "email"


      ## Options

      option :authorize_options, [:scope, :display, :auth_type]

      option :client_options, {
        authorize_url: "https://connect.mail.ru/oauth/authorize",
        site:          "https://connect.mail.ru", # used to request token as "THIS/oauth/token"
        token_url:     "oauth/token"              # URL is built in OAuth2::Client#token_url
      }

      option :info_fields, nil

      option :name, "mail_ru"

      option :redirect_url, nil


      ## Auth hash accessors

      info do
        {
          "birthday"   => raw_info["birthday"],
          "email"      => raw_info["email"],
          "image"      => raw_info["pick"],
          "first_name" => raw_info["first_name"],
          "last_name"  => raw_info["last_name"],
          "nickname"   => raw_info["nick"]
        }
      end

      extra do
        { "raw_info" => raw_info }
      end

      uid do
        raw_info["uid"]
      end


      ## OAuth mehtods

      private def callback_phase
        puts "In `callback_phase`, request.params: #{request.params.inspect}" if ENV['OAUTH_DEBUG'] == 'true'
        with_authorization_code! do
          super
        end
      rescue NoAuthorizationCodeError => e
        fail!(:no_authorization_code, e)
      end

      # /users/auth/mail_ru/callback"
      private def callback_url
        options[:redirect_url] || (full_host + script_name + callback_path)
      end


      ## Helper methods

      def raw_info
        maybe_json = fetch_raw_info
        parsed     = JSON.parse(maybe_json) rescue nil
        return {} unless parsed
        return {} unless parsed.is_a? Array
        return {} unless parsed.first
        parsed.first.sort.to_h
      end

      # You can pass +display+, +scope+, or +auth_type+ params to the auth request, if you need to set them dynamically.
      # You can also set these options in the OmniAuth config :authorize_params option.
      #
      def authorize_params
        super.tap do |params|
          %w[auth_type display revoke scope state].each do |v|
            next unless request.params[v]
            params[v.to_sym] = request.params[v]

            session["omniauth.state"] = params[:state] if v == "state"
            # to support omniauth-oauth2’s auto csrf protection
          end

          params[:scope] ||= DEFAULT_SCOPE
        end
      end


      private

      def fetch_raw_info
        @raw_info_json ||=  begin
          UserInfoFetcher.new(access_token: credentials["token"], app_id: client.id, secret_key: client.secret).call
        rescue UserInfoFetcher::FetchError => error
          fail!(:bad_request, error)
          ""
        end
      end

      def with_authorization_code!
        if request.params.has_key? "code"
          yield
        else
          raise NoAuthorizationCodeError, "должен содержать URI-параметр `code`"
        end
      end

    end
  end
end
