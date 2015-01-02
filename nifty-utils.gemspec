require File.expand_path('../lib/nifty/utils/version', __FILE__)

Gem::Specification.new do |s|
  s.name          = "nifty-utils"
  s.description   = "A set of useful utilties for Rails applications."
  s.summary       = "A collection of functions which expand upon ActiveRecord and ActionView."
  s.homepage      = "https://github.com/atech/nifty-utils"
  s.licenses      = ['MIT']
  s.version       = Nifty::Utils::VERSION
  s.files         = Dir.glob("{lib}/**/*")
  s.require_paths = ["lib"]
  s.authors       = ["Adam Cooke"]
  s.email         = ["adam@atechmedia.com"]
end
