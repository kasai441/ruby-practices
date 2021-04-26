#!/usr/bin/env ruby
# frozen_string_literal: true

require 'minitest/autorun'
require 'pathname'

require_relative '../../lib/segment/group'
require_relative '../test_helper'

module TestSegment
  class TestSegment::Group < Minitest::Test
    include TestHelper

    def setup
      segment, dir_path = prepare_variable_stats
      @unit = Segment::Group.new(segment, dir_path)
    end

    def test_display
      assert_equal('staff', @unit.display)
    end

    def test_need_space
      assert_equal(2, @unit.need_space(1))
      assert_equal(3, @unit.need_space(8))
    end
  end
end
