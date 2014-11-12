require 'nifty/utils/random_string'

class String

  def self.random(options = {})
    Nifty::Utils::RandomString.generate(options)
  end

  def ansi(code)
    "\e[#{code.to_s}m#{self}\e[0m"
  end

  def red
    self.ansi(31)
  end

  def green
    self.ansi(32)
  end

  def yellow
    self.ansi(33)
  end

  def blue
    self.ansi(34)
  end

end
