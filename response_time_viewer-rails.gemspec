$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "response_time_viewer/rails/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "response_time_viewer-rails"
  s.version     = ResponseTimeViewer::Rails::VERSION
  s.authors     = ["jiikko"]
  s.email       = ["n905i.1214@gmail.com"]
  s.homepage    = "https://github.com/jiikko/response_time_viewer-rails"
  s.summary     = "ResponseTimeViewer::Rails."
  s.description = s.summary
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "kaminari"
  s.add_dependency "rails", ">= 4.2"
  s.add_dependency "mysql2"

  s.add_development_dependency "rspec"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "spring"
  s.add_development_dependency "pry"
end
