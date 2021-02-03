#!/usr/bin/env ruby
# frozen_string_literal: true

require 'minitest/autorun'
require 'pathname'

require './lib/wc_run_app'

class WcDevTest < Minitest::Test
  TARGET_PATHNAME = Pathname('test/fixtures/sample')

  def test_run_app_pathname
    expected = <<-TEXT.chomp
       6      28     227 test/fixtures/sample/Rakefile
    TEXT
    pathname = TARGET_PATHNAME.join('Rakefile')
    params = { lines: true, words: true, bytes: true }
    assert_equal expected, run_app([pathname], nil, params)
  end

  def test_run_app_pathname_wildcard
    expected = <<-TEXT.chomp
      56     304    2180 test/fixtures/sample/Gemfile
      24      59     374 test/fixtures/sample/README.md
       6      28     227 test/fixtures/sample/Rakefile
       6      17     160 test/fixtures/sample/config.ru
wc: test/fixtures/sample/dummy: read: Is a directory
      11      19     222 test/fixtures/sample/package.json
wc: test/fixtures/sample/q: read: Is a directory
     103     427    3163 total
    TEXT
    pathname = TARGET_PATHNAME.join('*')
    params = { lines: true, words: true, bytes: true }
    assert_equal expected, run_app([pathname], nil, params)
  end

  def test_run_app_l
    expected = <<-TEXT.chomp
      56 test/fixtures/sample/Gemfile
      24 test/fixtures/sample/README.md
       6 test/fixtures/sample/Rakefile
       6 test/fixtures/sample/config.ru
wc: test/fixtures/sample/dummy: read: Is a directory
      11 test/fixtures/sample/package.json
wc: test/fixtures/sample/q: read: Is a directory
     103 total
    TEXT
    pathname = TARGET_PATHNAME.join('*')
    params = { lines: true, words: false, bytes: false }
    assert_equal expected, run_app([pathname], nil, params)
  end

  def test_run_app_w
    expected = <<-TEXT.chomp
     304 test/fixtures/sample/Gemfile
      59 test/fixtures/sample/README.md
      28 test/fixtures/sample/Rakefile
      17 test/fixtures/sample/config.ru
wc: test/fixtures/sample/dummy: read: Is a directory
      19 test/fixtures/sample/package.json
wc: test/fixtures/sample/q: read: Is a directory
     427 total
    TEXT
    pathname = TARGET_PATHNAME.join('*')
    params = { lines: false, words: true, bytes: false }
    assert_equal expected, run_app([pathname], nil, params)
  end

  def test_run_app_c
    expected = <<-TEXT.chomp
    2180 test/fixtures/sample/Gemfile
     374 test/fixtures/sample/README.md
     227 test/fixtures/sample/Rakefile
     160 test/fixtures/sample/config.ru
wc: test/fixtures/sample/dummy: read: Is a directory
     222 test/fixtures/sample/package.json
wc: test/fixtures/sample/q: read: Is a directory
    3163 total
    TEXT
    pathname = TARGET_PATHNAME.join('*')
    params = { lines: false, words: false, bytes: true }
    assert_equal expected, run_app([pathname], nil, params)
  end

  def test_run_app_pipe
    expected = <<-TEXT.chomp
      10      83     504
    TEXT
    input = `ls -la #{TARGET_PATHNAME}`
    params = { lines: true, words: true, bytes: true }
    assert_equal expected, run_app(nil, input, params)
  end
end
