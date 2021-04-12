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
      segment = 'size_test'
      prepare_data('size', segment, 5, 't')
      `cp -f #{TARGET_PATHNAME.join('../../Gemfile')} #{TARGET_PATHNAME.join('size')}`
      @dir_path = TARGET_PATHNAME.join('size')
      @unit1 = Segment::Size.new('size_test', @dir_path)
      @unit2 = Segment::Size.new('Gemfile', @dir_path)
    end

    def test_display
      assert_equal('0', @unit1.display)
      assert_equal('267', @unit2.display)
    end

    def test_need_space_should_return_diff_from_max_size
      assert_equal(4, @unit1.need_space(5))
      assert_equal(2, @unit2.need_space(5))
    end

    def test_stats_data
      Dir.mkdir(TARGET_PATHNAME.join('size/dir')) unless Dir.exist?(TARGET_PATHNAME.join('size/dir'))
      assert_equal('0', @unit1.stats_data)
      assert_equal('267', @unit2.stats_data)
      @unit3 = Segment::Size.new('dir', @dir_path)
      assert_equal('64', @unit3.stats_data)
    end
  end
end
