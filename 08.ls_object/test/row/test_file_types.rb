#!/usr/bin/env ruby
# frozen_string_literal: true

require 'minitest/autorun'

require_relative '../../lib/row/file_types'

module TestRow
  class TestRow::FileTypes < Minitest::Test
    def setup
      items = %w[d f d d f]
      @units = Row::FileTypes.new(items)
    end

    def test_max_unit
      @units.add_unit('test')
      assert_equal('test', @units.max_unit.name)
    end

    def test_add_space
      @units.add_unit('threeeee')
      @units.add_unit('00001111222233334444555566667777')
      @units.set_space
      assert_equal(0, @units.max_unit.space)
      assert_equal(31, @units.units[0].space)
      assert_equal(24, @units.units[5].space)
    end
  end
end
