# frozen_string_literal: true

require_relative 'roll'

class Frame
  attr_accessor :rolls

  def initialize
    @rolls = []
    @last = false
  end

  def roll(score)
    @rolls << Roll.new(score)
  end

  def score
    @rolls.map(&:score).sum
  end

  def last
    @last = true
  end

  def last?
    @last
  end

  def fix?
    # p @rolls
    if last?
      # 3投投げているか、2投で10点を超えていない
      @rolls.size == 3 || (@rolls.size == 2 && score < 10)
    else
      strike? || @rolls.size == 2
    end
  end

  def strike?
    @rolls.size == 1 && score == 10
  end

  def spare?
    @rolls.size == 2 && score == 10
  end
end
