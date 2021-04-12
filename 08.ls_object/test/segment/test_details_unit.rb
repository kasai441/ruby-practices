#!/usr/bin/env ruby
# frozen_string_literal: true

require 'minitest/autorun'

require_relative '../../lib/segment/details_unit'

module TestSegment
  class TestSegment::DetailsUnit < Minitest::Test
    def setup
      @unit = Segment::DetailsUnit.new('sample')
    end

    def test_display
      @unit.space = 1
      assert_equal(' sample', @unit.display)
    end

    def test_need_space_always_one
      assert_equal(1, @unit.need_space(0))
      assert_equal(1, @unit.need_space(1))
      assert_equal(1, @unit.need_space(100))
    end
  end
end
