#!/usr/bin/env ruby
# frozen_string_literal: true

require 'minitest/autorun'
require 'pathname'

require_relative '../../lib/segment/user'
require_relative '../test_helper'

module TestSegment
  class TestSegment::User < Minitest::Test
    include TestHelper

    def setup
      segment, dir_path = prepare_variable_stats
      @unit = Segment::User.new(segment, dir_path)
    end

    def test_display
      @unit.space = 0
      assert_equal(' kasai441', @unit.display)
    end
  end
end
