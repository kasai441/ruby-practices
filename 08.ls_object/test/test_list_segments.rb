#!/usr/bin/env ruby
# frozen_string_literal: true

require 'minitest/autorun'
require 'pathname'
require 'fileutils'

require_relative '../bin/ls'
require_relative '../lib/list_segments'
require_relative 'test_helper'

class TestListSegments < Minitest::Test # rubocop:disable Metrics/ClassLength
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

  def test_short_display_8x22chars
    prepare_files('8x22', 'zest000', 21)
    expected = <<~TEXT.chomp
      test0	test1	test10	test11	test12	test13	test14	test15	test16	test17	test18	test19	test2	test20	test3	test4	test5	test6	test7	test8	test9	zest000
    TEXT
    params = { a: false, l: false, r: false }
    # テスト環境の画面幅を確かめる
    assert_equal '178', `tput cols`.gsub(/\D/, '')
    list_files = ListSegments.new(TARGET_PATHNAME.join('8x22'), params, nil)
    assert_equal expected, list_files.display
    assert_equal 176, list_files.rows[0].size_total
  end

  def test_short_display_16x11_chars
    prepare_files('16x11', 'z' * 15, 10)
    expected = <<~TEXT.chomp
      test0		test1		test2		test3		test4		test5		test6		test7		test8		test9		zzzzzzzzzzzzzzz
    TEXT
    params = { a: false, l: false, r: false }
    # テスト環境の画面幅を確かめる
    assert_equal '178', `tput cols`.gsub(/\D/, '')
    list_files = ListSegments.new(TARGET_PATHNAME.join('16x11'), params, nil)
    assert_equal expected, list_files.display
    assert_equal 176, list_files.rows[0].size_total
  end

  def test_short_display_add_row
    prepare_files('add_row', 'zest000', 22)
    expected = <<~TEXT.chomp
      test0	test10	test12	test14	test16	test18	test2	test21	test4	test6	test8	zest000
      test1	test11	test13	test15	test17	test19	test20	test3	test5	test7	test9
    TEXT
    params = { a: false, l: false, r: false }
    # テスト環境の画面幅を確かめる
    assert_equal '178', `tput cols`.gsub(/\D/, '')
    list_files = ListSegments.new(TARGET_PATHNAME.join('add_row'), params, nil)
    assert_equal expected, list_files.display
    assert_equal 96, list_files.rows[0].size_total
    assert_equal 88, list_files.rows[1].size_total
  end

  def test_short_display_many_row # rubocop:disable Metrics/MethodLength
    prepare_files('many_rows', '0' * 16, 43)
    expected = <<~TEXT.chomp
      0000000000000000	test14			test20			test27			test33			test4			test8
      test0			test15			test21			test28			test34			test40			test9
      test1			test16			test22			test29			test35			test41
      test10			test17			test23			test3			test36			test42
      test11			test18			test24			test30			test37			test5
      test12			test19			test25			test31			test38			test6
      test13			test2			test26			test32			test39			test7
    TEXT
    params = { a: false, l: false, r: false }

    # テスト環境の画面幅を確かめる
    assert_equal '178', `tput cols`.gsub(/\D/, '')
    list_files = ListSegments.new(TARGET_PATHNAME.join('many_rows'), params, nil)
    assert_equal expected, list_files.display
    assert_equal 168, list_files.rows[0].size_total
    assert_equal 168, list_files.rows[1].size_total
    assert_equal 144, list_files.rows[2].size_total
    assert_equal 144, list_files.rows[3].size_total
    assert_equal 144, list_files.rows[4].size_total
    assert_equal 144, list_files.rows[5].size_total
    assert_equal 144, list_files.rows[6].size_total
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
