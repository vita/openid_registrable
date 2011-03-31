require File.expand_path('../lib/openid_registrable/version', __FILE__)

Gem::Specification.new do |s|
  s.name = "openid_registrable"
  s.summary = "Adds to model method for defining required and optional fields for registration via OpenID."
  s.description = "Gem makes possible define required and optional fields for registration via OpenID and to map them to fields of your model."
  s.authors = ['Vít Krchov']
  s.email = 'vit.krchov@gmail.com'
  s.homepage = 'https://github.com/vita/openid_registrable'

  s.version = OpenidRegistrable::VERSION
  s.platform = Gem::Platform::RUBY

  s.files        = `git ls-files`.split("\n")
  s.executables  = `git ls-files`.split("\n").map{|f| f =~ /^bin\/(.*)/ ? $1 : nil}.compact
  s.require_path = 'lib'

  s.add_dependency 'rails'

  s.add_development_dependency 'turn'
  s.add_development_dependency 'shoulda'
  s.add_development_dependency 'sqlite3'
end