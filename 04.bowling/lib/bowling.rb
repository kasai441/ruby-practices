#!/usr/bin/env ruby
# frozen_string_literal: true

class Roll < Struct.new(:id, :frame, :score, :bonus_count, :bonus, :feature)

  def keep_frame(bf)
    self.frame = bf.frame
  end

  # 前スローがストライクあるいは前フレームが2回投げ終わっているか
  def update_frame?(bf, bf2)
    bf.feature == :strike || (id >= 2 && bf.frame == bf2.frame)
  end

  def update_frame
    self.frame += 1
  end

  # 10点をとっていて、フレーム一投目かどうか、第10フレームではないか
  def strike?(bf)
    if score == 10
      id == 0 || (id >= 1 && frame != bf.frame && frame < 9)
    end
  end

  def spare?(bf)
    # puts [bf, self, " "]
    # raise '1投と2投の合計が10以上です'
    # フレーム2投目かどうか、フレームの合計が10かどうか、第10フレームではないか
    id > 0 && self.frame == bf.frame && self.score + bf.score == 10 && frame < 9
  end

  # ボーナスを先のスローに提供する
  def mark_strike(aft, aft2)
    self.feature = :strike
    aft.provide_bonus_count
    aft2.provide_bonus_count
  end

  def mark_spare(aft)
    self.feature = :spare
    aft.provide_bonus_count
  end

  def provide_bonus_count
    self.bonus_count += 1
  end

  def apply_bonus
    bonus = self.score * self.bonus_count
    self.bonus += bonus
  end
end

def main(input)
  scoreList = input.split(//)
  # パラメータ例外処理
  p scoreList
  # 空のフレーム作成
  rolls = []
  scoreList.each_with_index do |score, idx|
    score = 10 if score == "X"
    rolls << Roll.new(idx, 0, score.to_i, 0, 0, :none)
    # p rolls[idx]
  end
  rolls.each do |roll|
    before_2 = rolls[roll.id - 2]
    before_1 = rolls[roll.id - 1]
    after_1 = rolls[roll.id + 1]
    after_2 = rolls[roll.id + 2]

    # フレームを進める判定を行う
    roll.keep_frame(before_1)
    if roll.update_frame?(before_1, before_2)
      roll.update_frame
    end
    
    # puts [before_1, after_1, " "]

    # ストライクとスペアの判定を行う
    if roll.strike?(before_1)
      roll.mark_strike(after_1, after_2)
    elsif roll.spare?(before_1)
      roll.mark_spare(after_1)
    end
    
    # 提供されたボーナスを適用する
    roll.apply_bonus
  end
  rolls.each { |e| puts e }
  rolls.map { |e| e.score + e.bonus }.inject(:+)
end

# input = 'X'
input = 'X6390038273X9180X645'
puts main(input)
