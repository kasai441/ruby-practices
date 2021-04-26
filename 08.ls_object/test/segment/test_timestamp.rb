#!/usr/bin/env ruby
# frozen_string_literal: true

require 'minitest/autorun'
require 'pathname'

require_relative '../../lib/segment/timestamp'
require_relative '../test_helper'

module TestSegment
  class TestSegment::Timestamp < Minitest::Test
    include TestHelper

    def setup
      segment, dir_path = prepare_variable_stats
      @unit = Segment::Timestamp.new(segment, dir_path)
    end

    def test_display
      # テスト実行時の時間
      assert_equal('  4 13 14:37', @unit.display)
    end

    def test_need_space_always_zero
      assert_equal(0, @unit.need_space(1))
      assert_equal(0, @unit.need_space(5))
    end
  end
end
