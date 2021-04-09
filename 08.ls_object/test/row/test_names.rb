#!/usr/bin/env ruby
# frozen_string_literal: true

require 'minitest/autorun'

require_relative '../../lib/row/names'
# require_relative '../../lib/row/details'

module TestRow
  class TestRow::Names < Minitest::Test
    def setup
      items = %w[one two]
      @row_names = Row::Names.new(items)
    end

    def test_display
      @row_names.units[0].tab = 2
      @row_names.units[1].tab = 2
      assert_equal("one\t\ttwo", @row_names.display)
    end

    def test_max_unit
      @row_names.add_unit('threeeee')
      assert_equal('threeeee', @row_names.max_unit.name)
    end

    def test_add_tab_add_a_tab_per_8_chars
      @row_names.add_unit('threeeee')
      @row_names.add_unit('00001111222233334444555566667777')
      @row_names.set_tab
      assert_equal(1, @row_names.max_unit.tab)
      assert_equal(5, @row_names.units[0].tab)
      assert_equal(5, @row_names.units[1].tab)
      assert_equal(4, @row_names.units[2].tab)
    end

    def test_row_size
      @row_names.add_unit('threeeee')
      assert_equal(48, @row_names.size_total)
    end
  end
end
