# frozen_string_literal: true

require_relative 'row'
require_relative '../segment/file_type'

class Row::FileTypes
  include Row

  attr_accessor :units

  def initialize(items, max = nil)
    @units = items.map { |item| Segment::FileType.new(item) }
    @max = max
    set_space
  end

  def add_unit(name)
    @units << Segment::FileType.new(name)
    set_space
  end
end
