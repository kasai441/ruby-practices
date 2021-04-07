# frozen_string_literal: true

require_relative 'unit'

class Row
  attr_accessor :units

  def initialize(items)
    @units = items.map { |item| Unit.new(item) }
    add_tab
  end

  def display
    @units.last.reset_tab
    @units.map(&:display).join("\t")
  end

  def max
    @units.max_by { |v| v.name.size }
  end

  def add_tab
    @units.each do |unit|
      unit.add_tab(unit.need_tab(max.name.size))
    end
  end

  def add_unit(name)
    @units << Unit.new(name)
  end
end
