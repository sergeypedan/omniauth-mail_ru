require 'omniauth/mail_ru'
require 'omniauth'

module OmniAuth
  module Strategies
    autoload :MailRu, 'omniauth/strategies/mail_ru'
  end
end

OmniAuth.config.add_camelization 'mail_ru', 'MailRu'
