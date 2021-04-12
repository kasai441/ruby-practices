#!/usr/bin/env ruby
# frozen_string_literal: true

require 'minitest/autorun'
require 'pathname'

require_relative '../../lib/segment/type'
require_relative '../test_helper'

module TestSegment
  class TestSegment::Type < Minitest::Test
    include TestHelper

    def setup
      segment = 'f'
      prepare_data('type',segment, 5, 't')
      @dir_path = TARGET_PATHNAME.join('type')
      @unit = Segment::Type.new(segment, @dir_path)
    end

    def test_display
      @unit.space = 0
      assert_equal('-', @unit.display)
    end

    def test_need_space_always_zero
      assert_equal(0, @unit.need_space(1))
      assert_equal(0, @unit.need_space(5))
    end

    def test_to_char_ftype
      assert_equal('-', @unit.to_char_ftype('file'))
      assert_equal('d', @unit.to_char_ftype('directory'))
    end

    def test_get_data
      Dir.mkdir(TARGET_PATHNAME.join('type/dir')) unless Dir.exist?(TARGET_PATHNAME.join('type/dir'))
      assert_equal('-', @unit.get_data)
      @unit = Segment::Type.new('dir', @dir_path)
      assert_equal('d', @unit.get_data)
    end
  end
end
