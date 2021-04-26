#!/usr/bin/env ruby
# frozen_string_literal: true

require 'minitest/autorun'
require 'pathname'
require 'fileutils'

require_relative '../bin/ls'
require_relative '../lib/list_segments'
require_relative 'test_helper'

class TestListSegments < Minitest::Test
  include TestHelper

  def test_short_display_default
    prepare_files('seven', '0000111')
    expected = <<~TEXT.chomp
      0000111	test0	test1	test2	test3	test4	test5	test6	test7	test8	test9
    TEXT
    params = { a: false, l: false, r: false }
    assert_equal expected, ListSegments.new(TARGET_PATHNAME.join('seven'), params, nil).display
  end

  def test_short_display_add_tab
    prepare_files('eight', '00001111')
    expected = <<~TEXT.chomp
      00001111	test0		test1		test2		test3		test4		test5		test6		test7		test8		test9
    TEXT
    params = { a: false, l: false, r: false }
    assert_equal expected, ListSegments.new(TARGET_PATHNAME.join('eight'), params, nil).display
  end

  def test_apply_order_option_capital
    prepare_files('capital', 'Test50')
    expected = <<~TEXT.chomp
      Test50	test0	test1	test2	test3	test4	test5	test6	test7	test8	test9
    TEXT
    params = { a: false, l: false, r: false }
    assert_equal expected, ListSegments.new(TARGET_PATHNAME.join('capital'), params, nil).display
  end

  def test_apply_order_option_a
    prepare_files('opt_a', '.test0000000', 22)
    expected = <<~TEXT.chomp
      .		test0		test11		test14		test17		test2		test3		test6		test9
      ..		test1		test12		test15		test18		test20		test4		test7
      .test0000000	test10		test13		test16		test19		test21		test5		test8
    TEXT
    params = { a: true, l: false, r: false }
    assert_equal expected, ListSegments.new(TARGET_PATHNAME.join('opt_a'), params, nil).display
  end

  def test_apply_order_option_r
    prepare_files('opt_r', '.test00000000000', 22)
    expected = <<~TEXT.chomp
      test9			test5			test20			test17			test13			test1			.
      test8			test4			test2			test16			test12			test0
      test7			test3			test19			test15			test11			.test00000000000
      test6			test21			test18			test14			test10			..
    TEXT
    params = { a: true, l: false, r: true }
    assert_equal expected, ListSegments.new(TARGET_PATHNAME.join('opt_r'), params, nil).display
  end

  def test_details_display # rubocop:disable Metrics/MethodLength
    prepare_files('details', '.test00000000000', 22)
    Dir.mkdir(TARGET_PATHNAME.join('details/dir')) unless Dir.exist?(TARGET_PATHNAME.join('details/dir'))
    stats = %i[type mode nlink user group size timestamp name]
    # expectedはテスト作成時、ls実行結果を手動で反映すること
    expected = <<~TEXT.chomp
      total 0
      drwxr-xr-x  26 kasai441  staff  832  4 13 14:37 .
      drwxr-xr-x  15 kasai441  staff  480  4 13 14:37 ..
      -rw-r--r--   1 kasai441  staff    0  4 13 14:37 .test00000000000
      drwxr-xr-x   2 kasai441  staff   64  4 13 14:37 dir
      -rw-r--r--   1 kasai441  staff    0  4 13 14:37 test0
      -rw-r--r--   1 kasai441  staff    0  4 13 14:37 test1
      -rw-r--r--   1 kasai441  staff    0  4 13 14:37 test10
      -rw-r--r--   1 kasai441  staff    0  4 13 14:37 test11
      -rw-r--r--   1 kasai441  staff    0  4 13 14:37 test12
      -rw-r--r--   1 kasai441  staff    0  4 13 14:37 test13
      -rw-r--r--   1 kasai441  staff    0  4 13 14:37 test14
      -rw-r--r--   1 kasai441  staff    0  4 13 14:37 test15
      -rw-r--r--   1 kasai441  staff    0  4 13 14:37 test16
      -rw-r--r--   1 kasai441  staff    0  4 13 14:37 test17
      -rw-r--r--   1 kasai441  staff    0  4 13 14:37 test18
      -rw-r--r--   1 kasai441  staff    0  4 13 14:37 test19
      -rw-r--r--   1 kasai441  staff    0  4 13 14:37 test2
      -rw-r--r--   1 kasai441  staff    0  4 13 14:37 test20
      -rw-r--r--   1 kasai441  staff    0  4 13 14:37 test21
      -rw-r--r--   1 kasai441  staff    0  4 13 14:37 test3
      -rw-r--r--   1 kasai441  staff    0  4 13 14:37 test4
      -rw-r--r--   1 kasai441  staff    0  4 13 14:37 test5
      -rw-r--r--   1 kasai441  staff    0  4 13 14:37 test6
      -rw-r--r--   1 kasai441  staff    0  4 13 14:37 test7
      -rw-r--r--   1 kasai441  staff    0  4 13 14:37 test8
      -rw-r--r--   1 kasai441  staff    0  4 13 14:37 test9
    TEXT
    params = { a: true, l: true, r: false }
    assert_equal expected, ListSegments.new(TARGET_PATHNAME.join('details'), params, stats).display
  end

  def test_no_file
    prepare_files('no_file', nil, 0)
    params = { a: false, l: false, r: false }
    assert_nil ListSegments.new(TARGET_PATHNAME.join('no_file'), params, nil).display
  end
end
