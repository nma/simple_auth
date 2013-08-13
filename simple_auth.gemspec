$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "simple_auth/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "simple_auth"
  s.version     = SimpleAuth::VERSION
  s.authors     = ["nma"]
  s.email       = ["none@none.com"]
  s.homepage    = "https://github.com/nma"
  s.summary     = "Summary of SimpleAuth."
  s.description = "Description of SimpleAuth."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 3.2.13"
  s.add_dependency "bcrypt-ruby", "3.0.1"
  # s.add_dependency "jquery-rails"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'factory_girl_rails'
  s.test_files = Dir["spec/**/*"]
end
