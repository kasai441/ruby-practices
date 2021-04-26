# frozen_string_literal: true

require 'etc'

require_relative 'segment'

class Segment::User
  include Segment

  attr_accessor :value, :space

  def display
    SPACE_STRING + @value
  end

  private

  def choose(stat)
    @value = Etc.getpwuid(stat.uid).name
  end
end
