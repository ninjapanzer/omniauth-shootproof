lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "omniauth-shootproof/version"

Gem::Specification.new do |gem|
  gem.add_dependency "omniauth-oauth2", "~> 1.4"

  gem.add_development_dependency "bundler", "~> 1.0"

  gem.authors       = ["Paul Scarrone", "Gary Newsome"]
  gem.email         = ["paul@savvysoftworks.com", "gary@savvysoftworks.com"]
  gem.description   = "OAuth2 Strategy for Shootproof based upon Omniauth-OAuth2."
  gem.summary       = gem.description
  gem.homepage      = "https://github.com/SavvySoftWorksLLC/omniauth-shootproof"
  gem.licenses      = %w(MIT)

  gem.executables   = `git ls-files -- bin/*`.split("\n").collect { |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "omniauth-shootproof"
  gem.require_paths = %w(lib)
  gem.version       = OmniAuth::Shootproof::VERSION
end
