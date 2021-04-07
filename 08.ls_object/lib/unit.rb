# frozen_string_literal: true

class Unit
  TAB_SIZE = 8
  attr_accessor :name, :tab

  def initialize(name)
    @name = name
    @tab = 0
  end

  def display
    @name + "\t" * tab
  end

  def add_tab(num)
    @tab += num
  end

  def reset_tab
    @tab = 0
  end

  def need_tab(max_size)
    return 0 if max_size < TAB_SIZE

    diff = max_size - @name.size
    (diff / TAB_SIZE.to_f).ceil
  end
end
