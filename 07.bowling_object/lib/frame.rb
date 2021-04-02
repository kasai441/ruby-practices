# frozen_string_literal: true

require_relative 'roll'

class Frame
  attr_accessor :rolls

  def initialize(index)
    @index = index
    @rolls = []
  end

  def roll(score, index)
    @rolls << Roll.new(score, index)
  end

  def score
    @rolls.map(&:score).sum
  end

  def score_at(index)
    @rolls[index].score
  end

  def index_strike
    @rolls[0].index
  end

  def index_spare
    @rolls[1].index
  end

  def last?
    @index == 9
  end

  def fix?
    if last?
      # 最終フレームの終了条件
      # 3投投げているか、2投で10点に満たないこと
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
