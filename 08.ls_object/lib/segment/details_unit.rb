# frozen_string_literal: true

require_relative 'segment'

class Segment::DetailsUnit
  include Segment
  extend Segment

  attr_accessor :name, :space

  def need_space(_)
    1
  end

  def display
    SPACE_STRING * @space + @name
  end

  def choose(_)
    @name = name
  end
end
