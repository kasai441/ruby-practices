#!/usr/bin/env ruby
# frozen_string_literal: true

require 'minitest/autorun'
require 'pathname'

require_relative '../../lib/segment/size'
require_relative '../test_helper'

module TestSegment
  class TestSegment::Size < Minitest::Test
    include TestHelper

    def setup
      segment, dir_path = prepare_variable_stats
      @unit1 = Segment::Size.new(segment, dir_path)
      @unit2 = Segment::Size.new('Gemfile', dir_path)
      @unit3 = Segment::Size.new('dir', dir_path)
    end

    def test_display
      assert_equal('0', @unit1.display)
      assert_equal('267', @unit2.display)
      assert_equal('64', @unit3.display)
    end

    def test_need_space_should_return_diff_from_max_size
      assert_equal(11, @unit1.need_space(10))
      assert_equal(9, @unit2.need_space(10))
      assert_equal(10, @unit3.need_space(10))
    end

    def test_stats_data
      assert_equal('0', @unit1.stats_data)
      assert_equal('267', @unit2.stats_data)
      assert_equal('64', @unit3.stats_data)
    end
  end
end
