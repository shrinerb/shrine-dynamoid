Gem::Specification.new do |gem|
  gem.name          = "shrine-dynamoid"
  gem.version       = "0.1.0"

  gem.required_ruby_version = ">= 2.3"

  gem.summary      = "Provides Dynamoid integration for Shrine."
  gem.homepage     = "https://github.com/shrinerb/shrine-dynamoid"
  gem.authors      = ["Janko Marohnić", "Patryk Kotarski"]
  gem.email        = ["patrykkotarski21@gmail.com"]
  gem.license      = "MIT"

  gem.files        = Dir["README.md", "LICENSE.txt", "lib/**/*.rb", "*.gemspec"]
  gem.require_path = "lib"

  gem.add_dependency "shrine", ">= 3.0.0.beta2", "< 4"
  gem.add_dependency "dynamoid", ">= 2.2"

  gem.add_development_dependency "rake"
  gem.add_development_dependency "minitest"
  gem.add_development_dependency "mocha"
  gem.add_development_dependency "minitest-byebug"
end
