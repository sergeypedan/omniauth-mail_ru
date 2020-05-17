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
  s.version  = "0.0.1"

  s.files         = `git ls-files`.split("\n")
  # s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  # s.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency "omniauth-oauth2", "~> 1.2"

  s.add_development_dependency "rake"
end
