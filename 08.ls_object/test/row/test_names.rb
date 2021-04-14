#!/usr/bin/env ruby
# frozen_string_literal: true

require 'minitest/autorun'

require_relative '../test_helper'
require_relative '../../lib/list_segments'
require_relative '../../lib/row/names'

module TestRow
  class TestRow::Names < Minitest::Test
    include TestHelper

    def setup
      items = %w[one two]
      @units = Row::Names.new(items)
    end

    def test_display
      @units.units[0].space = 2
      @units.units[1].space = 2
      assert_equal("one\t\ttwo", @units.display)
    end

    def test_max_unit
      @units.add_unit('threeeee')
      assert_equal('threeeee', @units.max_unit.value)
    end

    def test_add_a_tab_per_8_chars
      @units.add_unit('threeeee')
      @units.add_unit('00001111222233334444555566667777')
      @units.set_space
      assert_equal(1, @units.max_unit.space)
      assert_equal(5, @units.units[0].space)
      assert_equal(5, @units.units[1].space)
      assert_equal(4, @units.units[2].space)
    end

    def test_row_size
      @units.add_unit('threeeee')
      assert_equal(48, @units.size_total)
    end

    def test_short_display_8x22chars
      prepare_files('8x22', 'zest000', 21)
      expected = <<~TEXT.chomp
        test0	test1	test10	test11	test12	test13	test14	test15	test16	test17	test18	test19	test2	test20	test3	test4	test5	test6	test7	test8	test9	zest000
      TEXT
      params = { a: false, l: false, r: false }
      # テスト環境の画面幅を確かめる
      assert_equal '178', `tput cols`.gsub(/\D/, '')
      path = TARGET_PATHNAME.join('8x22')
      list_files = Row::Names.new(ListSegments.new(path, params, nil).to_segments)
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
      path = TARGET_PATHNAME.join('16x11')
      list_files = Row::Names.new(ListSegments.new(path, params, nil).to_segments)
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
      path = TARGET_PATHNAME.join('add_row')
      list_files = Row::Names.new(ListSegments.new(path, params, nil).to_segments)
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
      path = TARGET_PATHNAME.join('many_rows')
      list_files = Row::Names.new(ListSegments.new(path, params, nil).to_segments)
      assert_equal expected, list_files.display
      assert_equal 168, list_files.rows[0].size_total
      assert_equal 168, list_files.rows[1].size_total
      assert_equal 144, list_files.rows[2].size_total
      assert_equal 144, list_files.rows[3].size_total
      assert_equal 144, list_files.rows[4].size_total
      assert_equal 144, list_files.rows[5].size_total
      assert_equal 144, list_files.rows[6].size_total
    end
  end
end
