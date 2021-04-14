# frozen_string_literal: true

class Roll
  attr_reader :score, :index

  def initialize(score, index)
    @score = score
    @index = index
  end
end
