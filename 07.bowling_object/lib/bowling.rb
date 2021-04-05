#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'game'

def argument_error?(input)
  if input.size.zero?
    '引数エラー：引数が必要です'
  elsif input.size > 1
    '引数エラー：引数はひとつのみです'
  elsif !input[0].match?(/^[\dX]+$/)
    '引数エラー：数字と"X"以外の引数です'
  end
end

def to_array(input)
  input.split(//).map do |i|
    i == 'X' ? 10 : i.to_i
  end
end

def put_error(message)
  puts message unless (ok = message.nil?)
  !ok
end

# 引数に不正がある場合メッセージを出力して処理終了
message = argument_error?(ARGV)
return if put_error(message)

game = Game.new(to_array(ARGV[0]))

# スコアに不正がある場合メッセージを出力して処理終了
message = game.error_message
return if put_error(message)

puts game.score
