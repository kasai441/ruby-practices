# frozen_string_literal: true

require_relative 'segment'

class Segment::Name
  include Segment
  extend Segment

  attr_accessor :value, :space

  def display
    @value + TAB_STRING * @space
  end

  def need_space(max_size)
    diff = max_size - @value.size
    (diff / TAB_SIZE.to_f).ceil
  end
end
