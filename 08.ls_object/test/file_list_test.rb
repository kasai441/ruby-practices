#!/usr/bin/env ruby
# frozen_string_literal: true

require 'minitest/autorun'
require 'pathname'
require 'fileutils'

require './lib/ls'
require './lib/file_list'

class FileListTest < Minitest::Test
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
    assert_equal expected, FileList.new(TARGET_PATHNAME.join('seven'), params).display
  end

  def test_short_display_add_tab
    prepare_data('eight', '00001111')
    expected = <<~TEXT.chomp
      00001111	test0		test1		test2		test3		test4		test5		test6		test7		test8		test9
    TEXT
    params = { a: false, l: false, r: false }
    assert_equal expected, FileList.new(TARGET_PATHNAME.join('eight'), params).display
  end

  def test_short_display_8x22chars
    prepare_data('8x22', 'zest000', 21)
    expected = <<~TEXT.chomp
      test0	test1	test10	test11	test12	test13	test14	test15	test16	test17	test18	test19	test2	test20	test3	test4	test5	test6	test7	test8	test9	zest000
    TEXT
    params = { a: false, l: false, r: false }
    # テスト環境の画面幅を確かめる
    assert_equal '178', `tput cols`.gsub(/\D/, '')
    file_list = FileList.new(TARGET_PATHNAME.join('8x22'), params)
    assert_equal 176, file_list.rows[0].size_total
    assert_equal expected, file_list.display
  end

  def test_short_display_16x11_chars
    prepare_data('16x11', 'z' * 15, 10)
    expected = <<~TEXT.chomp
      test0		test1		test2		test3		test4		test5		test6		test7		test8		test9		zzzzzzzzzzzzzzz
    TEXT
    params = { a: false, l: false, r: false }
    # テスト環境の画面幅を確かめる
    assert_equal '178', `tput cols`.gsub(/\D/, '')
    file_list = FileList.new(TARGET_PATHNAME.join('16x11'), params)
    assert_equal 176, file_list.rows[0].size_total
    assert_equal expected, file_list.display
  end

  # def test_short_display_176_chars
  #   prepare_data('176', '0' * 8, 10, "_" * 6)
  #   expected = <<~TEXT.chomp
  #     test0	test10	test12	test14	test16	test18	test2	test21	test4	test6	test8	z
  #     test1	test11	test13	test15	test17	test19	test20	test3	test5	test7	test9
  #   TEXT
  #   params = { a: false, l: false, r: false }
  #   # テスト環境の画面幅を確かめる
  #   assert_equal '178', `tput cols`.gsub(/\D/, '')
  #   file_list = FileList.new(TARGET_PATHNAME.join('176'), params)
  #   assert_equal 176, file_list.rows[0].size_total
  #   assert_equal expected, file_list.display
  # end
  #
  # def test_short_display_177_chars
  #   prepare_data('177', 'z', 22)
  #   expected = <<~TEXT.chomp
  #     test0	test10	test12	test14	test16	test18	test2	test21	test4	test6	test8	z
  #     test1	test11	test13	test15	test17	test19	test20	test3	test5	test7	test9
  #   TEXT
  #   params = { a: false, l: false, r: false }
  #   # テスト環境の画面幅を確かめる
  #   assert_equal '178', `tput cols`.gsub(/\D/, '')
  #   file_list = FileList.new(TARGET_PATHNAME.join('177'), params)
  #   assert_equal 177, file_list.rows[0].size_total
  #   assert_equal expected, file_list.display
  # end
  #
  # def test_short_display_178_chars
  #   prepare_data('178', 'zz', 22)
  #   expected = <<~TEXT.chomp
  #     test0	test10	test12	test14	test16	test18	test2	test21	test4	test6	test8	zz
  #     test1	test11	test13	test15	test17	test19	test20	test3	test5	test7	test9
  #   TEXT
  #   params = { a: false, l: false, r: false }
  #   # テスト環境の画面幅を確かめる
  #   assert_equal '178', `tput cols`.gsub(/\D/, '')
  #   file_list = FileList.new(TARGET_PATHNAME.join('178'), params)
  #   assert_equal 178, file_list.rows[0].size_total
  #   assert_equal expected, file_list.display
  # end

  def test_apply_order_option_capital
    prepare_data('capital', 'Test50')
    expected = <<~TEXT.chomp
      Test50	test0	test1	test2	test3	test4	test5	test6	test7	test8	test9
    TEXT
    params = { a: false, l: false, r: false }
    assert_equal expected, FileList.new(TARGET_PATHNAME.join('capital'), params).display
  end

  def test_apply_order_option_a

  end

  def test_apply_order_option_dot

  end

  def test_apply_order_option_r

  end

  private

  def prepare_data(dir, target, loop_num = 10, sample = 'test')
    return if Dir.exist?(TARGET_PATHNAME.join(dir))

    Dir.mkdir(TARGET_PATHNAME.join(dir))
    loop_num.times do |i|
      File.open(TARGET_PATHNAME.join("#{dir}/#{sample}#{i}"), 'w')
    end
    File.open(TARGET_PATHNAME.join("#{dir}/#{target}"), 'w')
  end
end
