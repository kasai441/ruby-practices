#!/usr/bin/env ruby
# frozen_string_literal: true

require 'minitest/autorun'
require 'pathname'

require_relative '../test_helper'
require_relative '../../lib/list_segments'
require_relative '../../lib/row/details'

module TestRow
  class TestRow::Details < Minitest::Test
    include TestHelper

    def setup
      prepare_data('row_details','00001111', 3, 't')
      dir_path = TARGET_PATHNAME.join('row_details')
      stats = %i[type name]
      segments = ListSegments.apply_order_option(Dir.foreach(dir_path).to_a, false, false)
      @rows = Row::Details.new(segments, nil, dir_path, stats)
    end

    def test_display
      expected = <<~TEXT.chomp
        - 00001111
        - t0
        - t1
        - t2
      TEXT
      assert_equal(expected, @rows.display)
    end
    #
    # def test_max_unit
    #   @rows.add_unit('threeeee')
    #   assert_equal('threeeee', @rows.max_unit.name)
    # end
    #
    # def test_add_a_tab_per_8_chars
    #   @rows.add_unit('threeeee')
    #   @rows.add_unit('00001111222233334444555566667777')
    #   @rows.set_space
    #   assert_equal(1, @rows.max_unit.space)
    #   assert_equal(5, @rows.units[0].space)
    #   assert_equal(5, @rows.units[1].space)
    #   assert_equal(4, @rows.units[2].space)
    # end
    #
    # def test_row_size
    #   @rows.add_unit('threeeee')
    #   assert_equal(48, @rows.size_total)
    # end
  end
end