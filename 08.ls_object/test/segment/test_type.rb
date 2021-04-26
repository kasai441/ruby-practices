#!/usr/bin/env ruby
# frozen_string_literal: true

require 'minitest/autorun'
require 'pathname'

require_relative '../../lib/segment/type'
require_relative '../test_helper'

module TestSegment
  class TestSegment::Type < Minitest::Test
    include TestHelper

    def setup
      segment, dir_path = prepare_variable_stats
      @unit = Segment::Type.new(segment, dir_path)
      @unit2 = Segment::Type.new('dir', dir_path)
    end

    def test_display
      @unit.space = 0
      assert_equal('-', @unit.display)
    end

    def test_need_space_always_zero
      assert_equal(0, @unit.need_space(1))
      assert_equal(0, @unit.need_space(5))
    end

    def test_stats_data
      assert_equal('-', @unit.stats_data)
      assert_equal('d', @unit2.stats_data)
    end
  end
end
