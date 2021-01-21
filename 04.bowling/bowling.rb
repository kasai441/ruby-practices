#!/usr/bin/env ruby
# frozen_string_literal: true

# class Score < Struct.new(:bonus, :throw)
#   def normal(score, throw)
#     throw.
#     # p self.total_score
#     # p "b" + bonus_score.to_s
#     self.total_score += (score + bonus_score)
#   end

#   def strike(throw)
#     normal(10)
#     throw.strike
#   end

#   def to_s
#     self.total_score.to_s
#   end
# end

class Throw < Struct.new(:idx, :score, :bonus)
  def update
    self.score = 10 if self.score == "X"
    self.score = self.score.to_i
    self.apply_bonus
  end

  def provide_bonus
    self.bonus += 1
  end

  def apply_bonus
    bonus = self.score * self.bonus
    self.score += bonus
  end
end

def calc_score
  input = "X123456789"
  scoreList = input.split(//)
  # パラメータ例外処理
  p scoreList
  # 空のフレーム作成
  throws = []
  scoreList.each_with_index do |score, idx|
      throws << Throw.new(idx, score, 0)
    p throws[idx]
  end
  throws.each do |throw|
    if ("0".."9").include?(throw.score)
      throw.update
    elsif "X" == throw.score
      throw.update
      throws[throw.idx + 1].provide_bonus
      throws[throw.idx + 2].provide_bonus
    else
      # raise 
    end
  end
  throws.map { |e| e.score }.inject(:+)
end

puts calc_score
