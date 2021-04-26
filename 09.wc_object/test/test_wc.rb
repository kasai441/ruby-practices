#!/usr/bin/env ruby
# frozen_string_literal: true

require 'minitest/autorun'
require 'pathname'

require_relative '../lib/word_count'

class WcDevTest < Minitest::Test
  TARGET_PATHNAME = Pathname('test/fixtures/sample')

  def test_pathname
    expected = <<~TEXT.chomp
      \       8      31     258 test/fixtures/sample/Rakefile
    TEXT
    pathname = TARGET_PATHNAME.join('Rakefile')
    actual = WordCount.new([pathname], nil, lines: true, words: true, bytes: true).display
    assert_equal expected, actual
  end

  def test_pathname_wildcard
    expected = <<~TEXT.chomp
      \      58     307    2203 test/fixtures/sample/Gemfile
      \      24      59     374 test/fixtures/sample/README.md
      \       8      31     258 test/fixtures/sample/Rakefile
      \       8      20     191 test/fixtures/sample/config.ru
      wc: test/fixtures/sample/dummy: read: Is a directory
      \      11      19     222 test/fixtures/sample/package.json
      wc: test/fixtures/sample/q: read: Is a directory
      \       3       8      72 test/fixtures/sample/space_sample
      \     112     444    3320 total
    TEXT
    pathname = TARGET_PATHNAME.join('*')
    actual = WordCount.new([pathname], nil, lines: true, words: true, bytes: true).display
    assert_equal expected, actual
  end

  def test_l
    expected = <<~TEXT.chomp
      \      58 test/fixtures/sample/Gemfile
      \      24 test/fixtures/sample/README.md
      \       8 test/fixtures/sample/Rakefile
      \       8 test/fixtures/sample/config.ru
      wc: test/fixtures/sample/dummy: read: Is a directory
      \      11 test/fixtures/sample/package.json
      wc: test/fixtures/sample/q: read: Is a directory
      \       3 test/fixtures/sample/space_sample
      \     112 total
    TEXT
    pathname = TARGET_PATHNAME.join('*')
    actual = WordCount.new([pathname], nil, lines: true, words: false, bytes: false).display
    assert_equal expected, actual
  end

  def test_w
    expected = <<~TEXT.chomp
      \     307 test/fixtures/sample/Gemfile
      \      59 test/fixtures/sample/README.md
      \      31 test/fixtures/sample/Rakefile
      \      20 test/fixtures/sample/config.ru
      wc: test/fixtures/sample/dummy: read: Is a directory
      \      19 test/fixtures/sample/package.json
      wc: test/fixtures/sample/q: read: Is a directory
      \       8 test/fixtures/sample/space_sample
      \     444 total
    TEXT
    pathname = TARGET_PATHNAME.join('*')
    actual = WordCount.new([pathname], nil, lines: false, words: true, bytes: false).display
    assert_equal expected, actual
  end

  def test_c
    expected = <<~TEXT.chomp
      \    2203 test/fixtures/sample/Gemfile
      \     374 test/fixtures/sample/README.md
      \     258 test/fixtures/sample/Rakefile
      \     191 test/fixtures/sample/config.ru
      wc: test/fixtures/sample/dummy: read: Is a directory
      \     222 test/fixtures/sample/package.json
      wc: test/fixtures/sample/q: read: Is a directory
      \      72 test/fixtures/sample/space_sample
      \    3320 total
    TEXT
    pathname = TARGET_PATHNAME.join('*')
    actual = WordCount.new([pathname], nil, lines: false, words: false, bytes: true).display
    assert_equal expected, actual
  end

  def test_pipe
    expected = <<-TEXT.chomp
      11      92     575
    TEXT
    input = `ls -la #{TARGET_PATHNAME}`
    actual = WordCount.new(nil, input, lines: true, words: true, bytes: true).display
    assert_equal expected, actual
  end
end
