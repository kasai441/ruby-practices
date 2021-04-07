#!/usr/bin/env ruby
# frozen_string_literal: true

require 'minitest/autorun'

require './lib/row'

class RowTest < Minitest::Test
  def setup
    items = %w[one two threeeee]
    @row = Row.new(items)
  end

  def test_display
    @row.units[0].add_tab(2)
    @row.units[1].add_tab(2)
    @row.units[2].add_tab(2)
    assert_equal("one\t\t\ttwo\t\t\tthreeeee", @row.display)
  end

  def test_max
    assert_equal('threeeee', @row.max.name)
  end

  def test_add_tab_add_a_tab_per_8_chars
    @row.add_unit('00001111222233334444555566667777')
    @row.add_tab
    assert_equal(0, @row.max.tab)
    assert_equal(4, @row.units[0].tab)
    assert_equal(3, @row.units[2].tab)
  end
end
