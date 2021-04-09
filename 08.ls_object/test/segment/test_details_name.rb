#!/usr/bin/env ruby
# frozen_string_literal: true

require 'minitest/autorun'

require_relative '../../lib/segment/details_name'

module TestSegment
  class TestSegment::DetailsName < Minitest::Test
    def setup
      @unit = Segment::DetailsName.new('sample')
    end

    def test_display
      @unit.space = 1
      assert_equal(' sample', @unit.display)
    end

    def test_need_space
      assert_equal(1, @unit.need_space(0))
      assert_equal(1, @unit.need_space(1))
      assert_equal(1, @unit.need_space(100))
    end
  end
end
