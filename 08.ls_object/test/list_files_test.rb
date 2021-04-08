#!/usr/bin/env ruby
# frozen_string_literal: true

require 'minitest/autorun'
require 'pathname'
require 'fileutils'

require './lib/ls'
require './lib/list_files'

class ListFilesTest < Minitest::Test
  TARGET_PATHNAME = Pathname('test/fixtures')

  def setup
    prepare_data('sample', 'sample')
  end

  def test_short_display_default
    prepare_data('seven', '0000111')
    expected = <<~TEXT.chomp
      0000111	test0	test1	test2	test3	test4	test5	test6	test7	test8	test9
    TEXT
    params = { a: false, l: false, r: false }
    assert_equal expected, ListFiles.new(TARGET_PATHNAME.join('seven'), params).display
  end

  def test_short_display_add_tab
    prepare_data('eight', '00001111')
    expected = <<~TEXT.chomp
      00001111	test0		test1		test2		test3		test4		test5		test6		test7		test8		test9
    TEXT
    params = { a: false, l: false, r: false }
    assert_equal expected, ListFiles.new(TARGET_PATHNAME.join('eight'), params).display
  end

  def test_short_display_8x22chars
    prepare_data('8x22', 'zest000', 21)
    expected = <<~TEXT.chomp
      test0	test1	test10	test11	test12	test13	test14	test15	test16	test17	test18	test19	test2	test20	test3	test4	test5	test6	test7	test8	test9	zest000
    TEXT
    params = { a: false, l: false, r: false }
    # テスト環境の画面幅を確かめる
    assert_equal '178', `tput cols`.gsub(/\D/, '')
    list_files = ListFiles.new(TARGET_PATHNAME.join('8x22'), params)
    assert_equal 176, list_files.rows[0].size_total
    assert_equal expected, list_files.display
  end

  def test_short_display_16x11_chars
    prepare_data('16x11', 'z' * 15, 10)
    expected = <<~TEXT.chomp
      test0		test1		test2		test3		test4		test5		test6		test7		test8		test9		zzzzzzzzzzzzzzz
    TEXT
    params = { a: false, l: false, r: false }
    # テスト環境の画面幅を確かめる
    assert_equal '178', `tput cols`.gsub(/\D/, '')
    list_files = ListFiles.new(TARGET_PATHNAME.join('16x11'), params)
    assert_equal 176, list_files.rows[0].size_total
    assert_equal expected, list_files.display
  end

  def test_short_display_add_row
    prepare_data('add_row', 'zest000', 22)
    expected = <<~TEXT.chomp
      test0	test10	test12	test14	test16	test18	test2	test21	test4	test6	test8	zest000
      test1	test11	test13	test15	test17	test19	test20	test3	test5	test7	test9
    TEXT
    params = { a: false, l: false, r: false }
    # テスト環境の画面幅を確かめる
    assert_equal '178', `tput cols`.gsub(/\D/, '')
    list_files = ListFiles.new(TARGET_PATHNAME.join('add_row'), params)
    assert_equal 96, list_files.rows[0].size_total
    assert_equal 88, list_files.rows[1].size_total
    assert_equal expected, list_files.display
  end

  def test_short_display_many_rows
    prepare_data('many_rows', '0' * 16, 43)
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
    list_files = ListFiles.new(TARGET_PATHNAME.join('many_rows'), params)
    assert_equal 168, list_files.rows[0].size_total
    assert_equal 168, list_files.rows[1].size_total
    assert_equal 144, list_files.rows[2].size_total
    assert_equal 144, list_files.rows[3].size_total
    assert_equal 144, list_files.rows[4].size_total
    assert_equal 144, list_files.rows[5].size_total
    assert_equal 144, list_files.rows[6].size_total
    assert_equal expected, list_files.display
  end

  def test_apply_order_option_capital
    prepare_data('capital', 'Test50')
    expected = <<~TEXT.chomp
      Test50	test0	test1	test2	test3	test4	test5	test6	test7	test8	test9
    TEXT
    params = { a: false, l: false, r: false }
    assert_equal expected, ListFiles.new(TARGET_PATHNAME.join('capital'), params).display
  end

  def test_apply_order_option_a

  end

  def test_apply_order_option_dot

  end

  def test_apply_order_option_r

  end

  def test_no_file
    prepare_data('no_file', nil, 0)
    params = { a: false, l: false, r: false }
    assert_nil ListFiles.new(TARGET_PATHNAME.join('no_file'), params).display
  end

  private

  def prepare_data(dir, target = nil, loop_num = 10, sample = 'test')
    return if Dir.exist?(TARGET_PATHNAME.join(dir))

    Dir.mkdir(TARGET_PATHNAME.join(dir))
    loop_num.times do |i|
      File.open(TARGET_PATHNAME.join("#{dir}/#{sample}#{i}"), 'w')
    end
    File.open(TARGET_PATHNAME.join("#{dir}/#{target}"), 'w') unless target.nil?
  end
end
