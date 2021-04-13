# frozen_string_literal: true

require 'etc'

require_relative 'segment'

class Segment::User
  include Segment

  attr_accessor :value, :space

  def display
    SPACE_STRING + @value
  end

  def choose(stat)
    @value = Etc.getpwuid(stat.uid).name
  end
end
