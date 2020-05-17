require "omniauth/strategies/oauth2"
# require "openssl"
# require "rack/utils"
# require "uri"

module OmniAuth
  module Strategies

    # @example Basic Usage
    #     use OmniAuth::Strategies::MailRu, 'API Key', 'Secret Key'
    #
    class MailRu < OmniAuth::Strategies::OAuth2
      class NoAuthorizationCodeError < StandardError; end

      DEFAULT_SCOPE = ""


      ## Options

      # option :access_token_options, {
      #   header_format: "OAuth %s",
      #   param_name:    "access_token"
      # }

      option :authorize_options, [:scope, :display, :auth_type]

      option :client_options, {
        authorize_url: "https://connect.mail.ru/oauth/authorize",
        site:          "https://connect.mail.ru",
        token_url:     "oauth/token"
      }

      option :info_fields, nil

      option :name, "mail_ru"

      option :redirect_url, nil


      ## Auth hash accessors

      info do
        prune!({
          "nickname"    => raw_info["username"],
          "email"       => raw_info["email"],
          "name"        => raw_info["name"],
          "first_name"  => raw_info["first_name"],
          "last_name"   => raw_info["last_name"],
          "description" => raw_info["bio"],
          "urls" => {
            "MailRu"  => raw_info["link"],
            "Website" => raw_info["website"]
          },
          "location" => (raw_info["location"] || {})["name"],
          "verified" => raw_info["verified"]
        })
      end

      extra do
        hash = {}
        hash["raw_info"] = raw_info
        prune! hash
      end

      uid do
        raw_info["id"]
      end


      ## OAuth mehtods

      private def callback_phase
        with_authorization_code! do
          super
        end
      rescue NoAuthorizationCodeError => e
        fail!(:no_authorization_code, e)
      end

      private def callback_url
        options[:redirect_url] || (full_host + script_name + callback_path)
      end


      ## Helper methods

      def raw_info
        @raw_info ||= access_token.get("me", info_options).parsed || {}
      end

      def info_options
        # fields = %w[nickname screen_name sex city country online bdate photo_50 photo_100 photo_200 photo_200_orig photo_400_orig]
        # fields.concat(options[:info_fields].split(',')) if options[:info_fields]
        # fields.join(',')
        {
          params: {
            fields: (options[:info_fields] || "name,email"),
            locale: options[:locale]
          }
        }
      end

      private def prune!(hash)
        hash.delete_if do |_, value|
          prune!(value) if value.is_a?(Hash)
          value.nil? || (value.respond_to?(:empty?) && value.empty?)
        end
      end

      # def access_token_options
      #   options.access_token_options.inject({}) { |h,(k,v)| h[k.to_sym] = v; h }
      # end

      # You can pass +display+, +scope+, or +auth_type+ params to the auth request, if you need to set them dynamically.
      # You can also set these options in the OmniAuth config :authorize_params option.
      #
      def authorize_params
        super.tap do |params|
          %w[auth_type display revoke scope state].each do |v|
            next unless request.params[v]
            params[v.to_sym] = request.params[v]

            session['omniauth.state'] = params[:state] if v == 'state'
            # to support omniauth-oauth2's auto csrf protection
          end

          params[:scope] ||= DEFAULT_SCOPE
        end
      end

      protected

      # def build_access_token
      #   super.tap do |token|
      #     token.options.merge!(access_token_options)
      #   end
      # end

      private

      def with_authorization_code!
        yield if request.params.has_key? "code"
        raise NoAuthorizationCodeError, "must contain `code` URI param"
      end

      def appsecret_proof
        @appsecret_proof ||= OpenSSL::HMAC.hexdigest(OpenSSL::Digest::SHA256.new, client.secret, access_token.token)
      end
    end
  end
end
