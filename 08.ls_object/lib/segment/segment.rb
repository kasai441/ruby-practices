# frozen_string_literal: true

module Segment
  TAB_STRING = "\t"
  TAB_SIZE = 8
  SPACE_STRING = ' '
  SPACE_SIZE = 1

  def reset_space
    @space = 0
  end

  def display
    @name + SPACE_STRING * @space
  end

  def need_space(max_size)
    max_size - @name.size
  end

  def tab_size
    TAB_SIZE
  end

  def space_size
    SPACE_SIZE
  end
end
