#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'game'

def arqument_error?
  # if ARGV.size.zero?
  #   abort '引数エラー：引数が必要です'
  # elsif ARGV.size > 1
  #   abort '引数エラー：引数はひとつのみです'
  # end
end

def correct_argument?(input)
  # abort '引数エラー：引数がnilです' if input.nil?
  # abort '引数エラー：数字と"X"以外の引数です' unless input.match?(/^(\d|X)+$/)
end

def to_array(input)
  input.split(//).map do |i|
    i == 'X' ? 10 : i.to_i
  end
end

arqument_error?
input = ARGV[0]
correct_argument?(input)
return if input.nil?

puts Game.new(to_array(input)).score
