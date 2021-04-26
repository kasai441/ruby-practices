#!/usr/bin/env ruby
# frozen_string_literal: true

require 'minitest/autorun'

require_relative '../../lib/segment/name'

module TestSegment
  class TestSegment::Name < Minitest::Test
    def setup
      @unit = Segment::Name.new('sample')
    end

    def test_display
      @unit.space = 2
      assert_equal("sample\t\t", @unit.display)
    end

    def test_need_tab
      assert_equal(2, @unit.need_space(22))
      assert_equal(3, @unit.need_space(23))
    end
  end
end
