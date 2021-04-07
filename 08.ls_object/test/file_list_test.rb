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

  def test_short_display_seven_characters
    p "画面幅: #{`tput cols`.gsub(/\D/, '')}"
    prepare_data('seven', '0000111')
    expected = <<~TEXT.chomp
      0000111	test0	test1	test2	test3	test4	test5	test6	test7	test8	test9
    TEXT
    params = { a: false, l: false, r: false }
    assert_equal expected, FileList.new(TARGET_PATHNAME.join('seven'), params).display
  end

  def test_short_display_eight_characters
    prepare_data('eight', '00001111')
    expected = <<~TEXT.chomp
      00001111	test0		test1		test2		test3		test4		test5		test6		test7		test8		test9
    TEXT
    params = { a: false, l: false, r: false }
    assert_equal expected, FileList.new(TARGET_PATHNAME.join('eight'), params).display
  end

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

  def prepare_data(dir, target)
    return if Dir.exist?(TARGET_PATHNAME.join(dir))

    Dir.mkdir(TARGET_PATHNAME.join(dir))
    10.times do |i|
      File.open(TARGET_PATHNAME.join("#{dir}/test#{i}"), 'w')
    end
    File.open(TARGET_PATHNAME.join("#{dir}/#{target}"), 'w')
  end
end
