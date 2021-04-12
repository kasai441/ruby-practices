#!/usr/bin/env ruby
# frozen_string_literal: true

require 'minitest/autorun'

require_relative '../test_helper'
require_relative '../../lib/list_segments'
require_relative '../../lib/row/types'

module TestRow
  class TestRow::Types < Minitest::Test
    include TestHelper

    def setup
      # prepare_data('ftype','00', 5, 't')
      # dir_path = TARGET_PATHNAME.join('ftype')
      # stats = %i[type name]
      # segments = ListSegments.apply_order_option(Dir.foreach(dir_path).to_a, false, false)
      # @units = Row::Types.new(segments, nil, dir_path, stats)
    end

    def test_max_unit
      # @units.add_unit('test')
      # assert_equal('test', @units.max_unit.name)
    end

    def test_set_space
      # @units.add_unit('threeeee')
      # @units.add_unit('00001111222233334444555566667777')
      # @units.set_space
      # p "@units#{@units.display}"
      # assert_equal(0, @units.max_unit.space)
      # assert_equal(31, @units.units[0].space)
      # assert_equal(24, @units.units[5].space)
    end
  end
end
