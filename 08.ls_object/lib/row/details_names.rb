# frozen_string_literal: true

require_relative 'row'
require_relative '../segment/details_name'

class Row::DetailsNames
  include Row

  attr_accessor :units

  def initialize(items, max = nil)
    @units = items.map { |item| Segment::DetailsName.new(item) }
    @max = max
    set_space
  end

  def add_unit(name)
    @units << Segment::DetailsName.new(name)
    set_space
  end
end
