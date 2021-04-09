#!/usr/bin/env ruby
# frozen_string_literal: true

require 'minitest/autorun'

require_relative '../../lib/row/details_names'

module TestRow
  class TestRow::DetailsNames < Minitest::Test
    def setup
      items = %w[one two]
      @units = Row::DetailsNames.new(items)
    end

    def test_always_one_space
      @units.add_unit('threeeee')
      @units.add_unit('00001111222233334444555566667777')
      @units.set_space
      assert_equal(1, @units.max_unit.space)
      assert_equal(1, @units.units[0].space)
      assert_equal(1, @units.units[1].space)
      assert_equal(1, @units.units[2].space)
    end
  end
end
