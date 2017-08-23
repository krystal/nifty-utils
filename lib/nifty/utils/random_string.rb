require "securerandom"

module Nifty
  module Utils
    class RandomString

      UPPER_LETTERS = ('A'..'Z').to_a
      LOWER_LETTERS = ('a'..'z').to_a
      LETTERS = UPPER_LETTERS + LOWER_LETTERS
      NUMBERS = (0..9).to_a
      WORD_CHARS = LETTERS + NUMBERS
      SYMBOLS = ['-', '!', '_', '@', '+', '*', '?', '%', '&', '/']

      def self.generate(options = {})
        options[:length]  ||= 30
        options[:symbols] ||= false
        chars = options[:upper_letters_only] ? UPPER_LETTERS : WORD_CHARS
        chars += SYMBOLS if options[:symbols]
        (
          [LETTERS[rand(LETTERS.size)]] +
          (0...options[:length]-2).map{ chars[SecureRandom.random_number(chars.size)] } +
          [LETTERS[rand(LETTERS.size)]]
        ).join
      end

    end
  end
end
