# frozen_string_literal: true

require_relative 'segment'

class Segment::Name
  include Segment
  extend Segment

  attr_accessor :name, :space

  def display
    @name + TAB_STRING * @space
  end

  def need_space(max_size)
    diff = max_size - @name.size
    (diff / TAB_SIZE.to_f).ceil
  end
end
