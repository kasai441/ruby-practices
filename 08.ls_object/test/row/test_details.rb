#!/usr/bin/env ruby
# frozen_string_literal: true

require 'minitest/autorun'
require 'pathname'

require_relative '../test_helper'
require_relative '../../lib/list_segments'
require_relative '../../lib/row/details'

module TestRow
  class TestRow::Details < Minitest::Test
    include TestHelper

    def setup
      prepare_data('row_details','00001111', 3, 't')
      dir_path = TARGET_PATHNAME.join('row_details')
      `cp -f #{TARGET_PATHNAME.join('../../Gemfile')} #{TARGET_PATHNAME.join('row_details')}`
      Dir.mkdir(TARGET_PATHNAME.join('row_details/dir')) unless Dir.exist?(TARGET_PATHNAME.join('row_details/dir'))
      stats = %i[type size name]
      segments = ListSegments.apply_order_option(Dir.foreach(dir_path).to_a, false, false)
      @rows = Row::Details.new(segments, nil, dir_path, stats)
    end

    def test_display
      expected = <<~TEXT.chomp
        -    0 00001111
        -  267 Gemfile
        d   64 dir
        -    0 t0
        -    0 t1
        -    0 t2
      TEXT
      assert_equal(expected, @rows.display)
    end
  end
end
