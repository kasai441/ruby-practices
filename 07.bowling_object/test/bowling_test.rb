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

  def test_argument_error_without_stdin
    assert_equal '引数エラー：引数が必要です', argument_error?([])
  end

  def test_argument_error_with_more_than_one_stdin
    assert_equal '引数エラー：引数はひとつのみです', argument_error?(['', ''])
  end

  def test_argument_error_with_unallowed_characters
    assert_equal '引数エラー：数字と"X"以外の引数です', argument_error?(['abc'])
  end

  def test_game_error_with_less_than_max_frame
    assert_equal '不正スコア：10フレーム未満のスコアです', Game.new(to_array('6390038273X9180XX0')).error_message
  end

  def test_game_error_with_more_than_max_frame
    assert_equal '不正スコア：10フレームを超えるスコアです', Game.new(to_array('6390038273X9180XX001')).error_message
  end
end
