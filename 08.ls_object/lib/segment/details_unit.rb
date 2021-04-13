# frozen_string_literal: true

require_relative 'segment'

class Segment::DetailsUnit
  include Segment

  attr_accessor :value, :space

  def need_space(_)
    1
  end

  def display
    SPACE_STRING * @space + @value
  end

  def choose(_)
    @value
  end
end
