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
      _, dir_path = prepare_variable_stats
      stats = %i[type mode nlink user group size timestamp name]
      segments = ListSegments.apply_order_option(Dir.foreach(dir_path).to_a, false, false)
      @rows = Row::Details.new(segments, dir_path, stats)
    end

    def test_display
      expected = <<~TEXT.chomp
        total 8
        -rw-r--r--  1 kasai441  staff  267  4 13 15:34 Gemfile
        drwxr-xr-x  2 kasai441  staff   64  4 13 14:37 dir
        -rw-r--r--  1 kasai441  staff    0  4 13 14:37 t0
        -rw-r--r--  1 kasai441  staff    0  4 13 14:37 t1
        -rw-r--r--  1 kasai441  staff    0  4 13 14:37 t2
        -rw-r--r--  1 kasai441  staff    0  4 13 14:37 t3
        -rw-r--r--  1 kasai441  staff    0  4 13 14:37 t4
        -rw-r--r--  1 kasai441  staff    0  4 13 14:37 variable_stats
      TEXT
      assert_equal(expected, @rows.display)
    end
  end
end
