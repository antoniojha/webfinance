
class Test
  attr_reader :value # allow value to be called instead of @value
  def initialize (val=0)
    @value=val
  end
  def get_val
    value
  end
end

