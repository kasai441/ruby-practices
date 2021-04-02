# frozen_string_literal: true

require 'minitest/autorun'
require './lib/bowling'
require './lib/game'

class GameTest < Minitest::Test
  def test_score
    assert_equal 139, Game.new(to_array('6390038273X9180X645')).score
  end

  def test_score2
    assert_equal 164, Game.new(to_array('6390038273X9180XXXX')).score
  end

  def test_score3
    assert_equal 107, Game.new(to_array('0X150000XXX518104')).score
  end

  def test_score4
    assert_equal 134, Game.new(to_array('6390038273X9180XX00')).score
  end

  def test_score5
    assert_equal 300, Game.new(to_array('XXXXXXXXXXXX')).score
  end

  # def test_argument_error
  #   assert_equal '引数エラー：数字と"X"以外の引数です', total_score(list_rolls('abc'))
  # end
end
