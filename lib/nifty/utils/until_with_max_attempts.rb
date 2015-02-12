module Nifty
  module Utils
    module UntilWithMaxAttempts

      #
      # The exception which will be raised if the maximum number of attempts
      # is reached.
      #
      class MaxAttemptsReached < StandardError; end

      #
      # Like a usual while block but with a maximum attempt counter. Can be used
      # like this
      #
      #    Attempts.until proc { job.completed? }, :attempts => 10, :gap => 5 do
      #      puts "Waiting for job to complete..."
      #    end
      #
      # The proc is the condition which will be evaluated, :attempts sets the
      # maximum number of times it will wait before raising an exception and :gap
      # is the length of time in seconds to wait between each check.
      #
      def self.until(condition, options = {}, &block)
        options[:attempts] ||= 10
        count = 0
        until condition.call

          if count == options[:attempts]
            raise MaxAttemptsReached, "Maximum attempts reached (#{options[:attempts]}) without success"
          end

          yield

          count += 1

          if options[:gap] && count < options[:attempts]
            sleep options[:gap]
          end

        end
      end

    end
  end
end
