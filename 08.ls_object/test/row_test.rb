#!/usr/bin/env ruby
# frozen_string_literal: true

require 'minitest/autorun'

require './lib/row'

class RowTest < Minitest::Test
  def setup
    items = %w[one two]
    @row = Row.new(items)
  end

  def test_display
    @row.units[0].tab = 2
    @row.units[1].tab = 2
    assert_equal("one\t\ttwo", @row.display)
  end

  def test_max_unit
    @row.add_unit('threeeee')
    assert_equal('threeeee', @row.max_unit.name)
  end

  def test_add_tab_add_a_tab_per_8_chars
    @row.add_unit('threeeee')
    @row.add_unit('00001111222233334444555566667777')
    @row.set_tab
    assert_equal(1, @row.max_unit.tab)
    assert_equal(5, @row.units[0].tab)
    assert_equal(5, @row.units[1].tab)
    assert_equal(4, @row.units[2].tab)
  end

  def test_row_size
    @row.add_unit('threeeee')
    assert_equal(48, @row.size_total)
  end
end
