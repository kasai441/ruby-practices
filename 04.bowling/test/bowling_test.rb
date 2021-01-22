# frozen_string_literal: true

require 'minitest/autorun'
require './lib/bowling'

class BowlingTest < Minitest::Test
  def test_list_rolls
    assert_equal 139, total_score(list_rolls('6390038273X9180X645'))
    assert_equal 164, total_score(list_rolls('6390038273X9180XXXX'))
    assert_equal 107, total_score(list_rolls('0X150000XXX518104'))
    assert_equal 134, total_score(list_rolls('6390038273X9180XX00'))
    assert_equal 300, total_score(list_rolls('XXXXXXXXXXXX'))
  end

  def test_argument_error
    assert_equal '引数エラー：数字と"X"以外の引数です', total_score(list_rolls('abc'))
  end
end

