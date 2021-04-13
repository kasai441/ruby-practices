#!/usr/bin/env ruby
# frozen_string_literal: true

require 'minitest/autorun'
require 'pathname'

require_relative '../test_helper'
require_relative '../../lib/list_segments'
require_relative '../../lib/row/details_stats'

module TestRow
  class TestRow::DetailsStats < Minitest::Test
    include TestHelper

    def setup
      @segment, @dir_path = prepare_variable_stats
      @segments = ListSegments.apply_order_option(Dir.foreach(@dir_path).to_a, false, false)
    end

    def test_display_type
      stat = :type
      rows = Row::DetailsStats.new(@segments, @dir_path, stat)
      assert_equal(%w[- d - - - - - -], rows.display)
    end

    def test_display_unit
      stat = :size
      rows = Row::DetailsStats.new(@segments, @dir_path, stat)
      assert_equal(['  267', '   64', '    0', '    0', '    0', '    0', '    0', '    0'], rows.display)
    end

    def test_display_unit_name
      stat = :name
      rows = Row::DetailsStats.new(@segments, @dir_path, stat)
      assert_equal([' Gemfile', ' dir', ' t0', ' t1', ' t2', ' t3', ' t4', ' variable_stats'], rows.display)
    end

    def test_display_blocks
      stat = :blocks
      rows = Row::DetailsStats.new(@segments, @dir_path, stat)
      assert_equal([8, 0, 0, 0, 0, 0, 0, 0], rows.display)
    end
  end
end
