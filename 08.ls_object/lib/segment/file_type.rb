# frozen_string_literal: true

require_relative 'segment'

class Segment::FileType
  include Segment
  extend Segment

  attr_accessor :name, :space

  def initialize(name)
    @name = name
    @space = 0
  end
end
