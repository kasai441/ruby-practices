#!/usr/bin/env ruby
# frozen_string_literal: true

require 'minitest/autorun'

require_relative '../../lib/segment/file_type'

module TestSegment
  class TestSegment::FileType < Minitest::Test
    def setup
      @unit = Segment::FileType.new('f')
    end

    def test_display
      @unit.space = 0
      assert_equal('f', @unit.display)
    end

    def test_need_space
      assert_equal(0, @unit.need_space(1))
      assert_equal(4, @unit.need_space(5))
    end
  end
end
