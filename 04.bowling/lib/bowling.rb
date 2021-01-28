#!/usr/bin/env ruby
# frozen_string_literal: true

Roll = Struct.new(:id, :frame, :score, :bonus, :feature) do
  def keep_frame(bf1)
    self.frame = bf1.frame
  end

  # フレーム更新判定：前スローがストライクあるいは前フレームが2回投げ終わっているか
  def update_frame?(bf1, bf2)
    bf1.feature == :strike || (id >= 2 && bf1.frame == bf2.frame)
  end

  def update_frame
    self.frame += 1
  end

  # ストライク判定：10点をとっていて、フレーム一投目かどうか、第10フレームではないか
  def strike?(bf1)
    return false unless score == 10

    id.zero? || (id >= 1 && self.frame != bf1.frame && self.frame < 9)
  end

  # スペア判定：フレームの合計が10で、フレーム2投目かどうか、第10フレームではないか
  def spare?(bf1)
    return false unless score + bf1.score == 10

    id.positive? && self.frame == bf1.frame && self.frame < 9
  end

  # ストライクボーナスを先のスローから取得する
  def mark_strike(aft1, aft2)
    self.feature = :strike
    self.bonus += aft1.score
    self.bonus += aft2.score
  end

  # スペアボーナスを先のスローから取得する
  def mark_spare(aft1)
    self.feature = :spare
    self.bonus += aft1.score
  end
end

def list_rolls(input)
  # パラメータ例外処理
  return '引数エラー：引数がnilです' if input.nil?
  return '引数エラー：数字と"X"以外の引数です' unless input.match?(/^(\d|X)+$/)

  rolls = []
  input.split(//).each_with_index do |score, idx|
    score = 10 if score == 'X'
    rolls << Roll.new(idx, 0, score.to_i, 0, :none)
  end
  rolls
end

def total_score(rolls)
  return rolls if rolls.is_a?(String)

  rolls.each do |roll|
    bf2 = rolls[roll.id - 2]
    bf1 = rolls[roll.id - 1]
    aft1 = rolls[roll.id + 1]
    aft2 = rolls[roll.id + 2]

    # フレームを進める判定を行う
    roll.keep_frame(bf1)
    roll.update_frame if roll.update_frame?(bf1, bf2)

    # ストライクとスペアの判定を行う
    if roll.strike?(bf1)
      roll.mark_strike(aft1, aft2)
    elsif roll.spare?(bf1)
      roll.mark_spare(aft1)
    end
  end
  rolls.map { |e| e.score + e.bonus }.sum
end

if ARGV.size.zero?
  puts '引数エラー：引数が必要です'
elsif ARGV.size > 1
  puts '引数エラー：引数はひとつのみです'
end

input = ARGV[0]

rolls = list_rolls(input)

puts total_score(rolls)
