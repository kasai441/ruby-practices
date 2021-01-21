#!/usr/bin/env ruby
# frozen_string_literal: true

class Throw < Struct.new(:id, :frame, :score, :bonus_count, :bonus)
  def update
    self.score = 10 if self.score == "X"
    self.score = self.score.to_i
  end

  def next_frame(previous, pre_previous)
    self.frame = previous.frame
    if (!pre_previous.nil? && previous.frame == pre_previous.frame) || previous.score == 10
      self.frame += 1
    end
  end

  def spare?(previous)
    # raise '1投と2投の合計が10以上です'
    !self.frame.zero? && self.score + previous.score == 10
  end

  def provide_bonus_count
    self.bonus_count += 1
  end

  def apply_bonus
    bonus = self.score * self.bonus_count
    self.bonus += bonus
  end
end

def main
  input = "X123456789"
  input = "6390038273X9180X645"
  input = "6390038273X9180XXXX"
  input = "0X150000XXX518104"
  # input = "6390038273X9180XX00"
  # input = "XXXXXXXXXXXX"
  scoreList = input.split(//)
  # パラメータ例外処理
  p scoreList
  # 空のフレーム作成
  throws = []
  scoreList.each_with_index do |score, idx|
    throws << Throw.new(idx, 0, score, 0, 0)
    # p throws[idx]
  end
  throws.each do |throw|
    if ("0".."9").include?(throw.score)
      throw.update
      if throw.id >= 2
        throw.next_frame(throws[throw.id - 1], throws[throw.id - 2])
      end
      if (throw.spare?(throws[throw.id - 1])) && throw.frame < 9
        throws[throw.id + 1].provide_bonus_count
      end
    elsif "X" == throw.score
      throw.update
      if throw.id >= 1
        throw.next_frame(throws[throw.id - 1], nil)
      end
      if throw.frame < 9
        throws[throw.id + 1].provide_bonus_count
        throws[throw.id + 2].provide_bonus_count
      end
    else
      # raise 
    end
    throw.apply_bonus#(throws[throw.id - 1]) if throw.id > 0
  end
  throws.each { |e| puts e }
  throws.map { |e| e.score + e.bonus }.inject(:+)
end

puts main
