require 'nifty/utils/until_with_max_attempts'

class Object

  def until_with_max_attempts(*args,  &block)
    Nifty::Utils::UntilWithMaxAttempts.until(*args, &block)
  end

end
