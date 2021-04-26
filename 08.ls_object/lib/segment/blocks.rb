# frozen_string_literal: true

require_relative 'segment'

class Segment::Blocks
  include Segment

  attr_accessor :value, :space

  def display
    @value
  end

  private

  def choose(stat)
    @value = stat.blocks
  end
end
