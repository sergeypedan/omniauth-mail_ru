# -*- encoding: utf-8 -*-
# frozen_string_literal: true

$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.authors  = ["Sergey Pedan"]
  s.email    = ["sergey.pedan@gmail.com"]
  s.homepage = "https://github.com/sergeypedan/omniauth-mail_ru"
  s.license  = "MIT"
  s.name     = "omniauth-mail_ru"
  s.summary  = "MailRu OAuth2 Strategy for OmniAuth"
  s.version  = "0.0.2"

  s.files         = `git ls-files`.split("\n")
  s.require_paths = ["lib"]

  s.add_development_dependency "rake"

  s.add_runtime_dependency "omniauth-oauth2", "~> 1"
end
