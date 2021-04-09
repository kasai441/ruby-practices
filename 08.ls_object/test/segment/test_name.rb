#!/usr/bin/env ruby
# frozen_string_literal: true

require 'minitest/autorun'

require_relative '../../lib/segment/name'

module TestSegment
  class TestSegment::Name < Minitest::Test
    def setup
      @segment_name = Segment::Name.new('sample')
    end

    def test_display
      @segment_name.tab = 2
      assert_equal("sample\t\t", @segment_name.display)
    end

    def test_need_tab
      assert_equal(2, @segment_name.need_tab(22))
      assert_equal(3, @segment_name.need_tab(23))
    end
  end
end
