#!/usr/bin/env ruby
# frozen_string_literal: true

class Throwing < Struct.new(:id, :frame, :score, :bonus_count, :bonus, :strike, :spare)
  def update
    self.score = 10 if self.score == "X"
    self.score = self.score.to_i
  end

  def previous_frame(previous)
    self.frame = previous.frame
  end

  def forward_frame
    self.frame += 1
  end

  def spare?(previous)
    # p [previous, self]
    # raise '1投と2投の合計が10以上です'
    self.score + previous.score == 10
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
  throwings = []
  scoreList.each_with_index do |score, idx|
    throwings << Throwing.new(idx, 0, score, 0, 0, false, false)
    # p throwings[idx]
  end
  throwings.each do |throwing|
    back_1 = throwings[throwing.id - 1]
    back_2 = throwings[throwing.id - 2]
    next_1 = throwings[throwing.id + 1]
    next_2 = throwings[throwing.id + 2]

    throwing.previous_frame(back_1)
    # ストライク
    if "X" == throwing.score
      if throwing.id > 0 && back_1.score != 0
        throwing.strike = true
      end
      throwing.update
      if (throwing.id >= 2 && back_1.frame == back_2.frame) || back_1.strike
        throwing.forward_frame
      end
      if throwing.frame < 9
        next_1.provide_bonus_count
        next_2.provide_bonus_count
      end
    elsif ("0".."9").include?(throwing.score) || "X" == throwing.score
      throwing.update
      if (throwing.id >= 2 && back_1.frame == back_2.frame) || back_1.strike
          throwing.forward_frame
      end
      # スペア
      if (throwing.id > 0 && throwing.spare?(back_1)) && throwing.frame < 9
        throwing.spare = true
        next_1.provide_bonus_count
      end
    else
      # raise 
    end
    throwing.apply_bonus#(back_1) if throwing.id > 0
  end
  throwings.each { |e| puts e }
  throwings.map { |e| e.score + e.bonus }.inject(:+)
end

puts main
