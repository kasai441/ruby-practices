#!/usr/bin/env ruby
# frozen_string_literal: true

require 'minitest/autorun'
require 'pathname'
require 'fileutils'

require './lib/ls'
require './lib/file_list'

class WcDevTest < Minitest::Test
  TARGET_PATHNAME = Pathname('test/fixtures/sample')

  def setup
    Dir.mkdir(TARGET_PATHNAME.join('07')) unless Dir.exist?(TARGET_PATHNAME.join('07'))
    10.times do |i|
      File.open(TARGET_PATHNAME.join("07/test#{i}"), 'w')
    end
    File.open(TARGET_PATHNAME.join('07/0000111'), 'w')
    FileUtils.cp_r(TARGET_PATHNAME.join('07'), TARGET_PATHNAME.join('08'))
    File.open(TARGET_PATHNAME.join('08/00001111'), 'w')

  end

  def test_short_display_seven_characters
    expected = <<-TEXT.chomp
0000111	test0	test1	test2	test3	test4	test5	test6	test7	test8	test9
    TEXT
    params = { a: false, l: false, r: false }
    p `tput cols`.gsub(/\D/, '').to_i
    assert_equal expected, FileList.new(TARGET_PATHNAME.join('07'), params).display
  end

  def test_short_display_eight_characters
    expected = <<-TEXT.chomp
00001111	test0		test2		test4		test6		test8
07		test1		test3		test5		test7		test9
    TEXT
    params = { a: false, l: false, r: false }
    assert_equal expected, FileList.new(TARGET_PATHNAME.join('08'), params).display
  end

end
