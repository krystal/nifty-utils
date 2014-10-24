module Nifty
  module Utils
    class RandomString
  
      LETTERS = ('A'..'Z').to_a + ('a'..'z').to_a
      NUMBERS = (0..9).to_a
      WORD_CHARS = LETTERS + NUMBERS
      SYMBOLS = ['-', '!', '_', '@', '+', '*', '?', '%', '&', '/']
  
      def self.generate(options = {})
        options[:length]  ||= 30
        options[:symbols] ||= false
        chars = WORD_CHARS
        chars += SYMBOLS if options[:symbols]
        (
          [LETTERS[rand(LETTERS.size)]] +
          (0...options[:length]-2).map{ chars[rand(chars.size)] } +
          [LETTERS[rand(LETTERS.size)]]
        ).join
      end
  
    end
  end
end
