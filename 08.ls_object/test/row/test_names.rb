#!/usr/bin/env ruby
# frozen_string_literal: true

require 'minitest/autorun'

require_relative '../../lib/row/names'

module TestRow
  class TestRow::Names < Minitest::Test
    def setup
      items = %w[one two]
      @units = Row::Names.new(items)
    end

    def test_display
      @units.units[0].space = 2
      @units.units[1].space = 2
      assert_equal("one\t\ttwo", @units.display)
    end

    def test_max_unit
      @units.add_unit('threeeee')
      assert_equal('threeeee', @units.max_unit.name)
    end

    def test_add_a_tab_per_8_chars
      @units.add_unit('threeeee')
      @units.add_unit('00001111222233334444555566667777')
      @units.set_space
      assert_equal(1, @units.max_unit.space)
      assert_equal(5, @units.units[0].space)
      assert_equal(5, @units.units[1].space)
      assert_equal(4, @units.units[2].space)
    end

    def test_row_size
      @units.add_unit('threeeee')
      assert_equal(48, @units.size_total)
    end
  end
end
