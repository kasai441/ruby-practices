# frozen_string_literal: true

require_relative 'segment'

class Segment::DetailsUnit
  include Segment

  attr_accessor :value, :space

  def display
    SPACE_STRING * @space + @value
  end

  def need_space(_)
    1
  end

  private

  def choose(_)
    @value
  end
end
