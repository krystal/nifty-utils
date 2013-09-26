require File.expand_path('../lib/nifty/utils/version', __FILE__)

Gem::Specification.new do |s|
  s.name          = "nifty-utils"
  s.description   = %q{A set of useful utilties for Rails applications}
  s.summary       = s.description
  s.homepage      = "https://github.com/niftyware/utils"
  s.version       = Nifty::Utils::VERSION
  s.files         = Dir.glob("{lib}/**/*")
  s.require_paths = ["lib"]
  s.authors       = ["Adam Cooke"]
  s.email         = ["adam@niftyware.io"]
end
