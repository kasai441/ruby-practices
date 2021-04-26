#!/usr/bin/env ruby
# frozen_string_literal: true

require 'minitest/autorun'
require 'pathname'

require_relative '../../lib/segment/nlink'
require_relative '../test_helper'

module TestSegment
  class TestSegment::Nlink < Minitest::Test
    include TestHelper

    def setup
      segment, dir_path = prepare_variable_stats
      @unit = Segment::Nlink.new(segment, dir_path)
    end

    def test_display
      assert_equal('1', @unit.display)
    end

    def test_need_space_should_be_more_than_two
      assert_equal(2, @unit.need_space(1))
      assert_equal(6, @unit.need_space(5))
    end
  end
end
