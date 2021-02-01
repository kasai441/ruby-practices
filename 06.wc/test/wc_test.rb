#!/usr/bin/env ruby
# frozen_string_literal: true

require 'minitest/autorun'
require 'stringio'
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
    assert_equal expected, run_app([pathname], nil, **params)
  end

  def test_run_app_pathname_wildcard
    expected = <<-TEXT.chomp
       6      17     160 test/fixtures/sample/config.ru
wc: test/fixtures/sample/dummy: Is a directory
       0       0       0 test/fixtures/sample/dummy
      56     304    2180 test/fixtures/sample/Gemfile
      11      19     222 test/fixtures/sample/package.json
wc: test/fixtures/sample/q: Is a directory
       0       0       0 test/fixtures/sample/q
       6      28     227 test/fixtures/sample/Rakefile
      24      59     374 test/fixtures/sample/README.md
     103     427    3163 total
    TEXT
    pathname = TARGET_PATHNAME + '/Rakefile'
    assert_equal expected, run_app(pathname, nil)
  end

  def test_run_app_pipe
  end

  def test_stdin
    test_input = <<~TEXT.chomp
      first
      second
      third
    TEXT
    # assert_equal("3\n", output.lines[-1]) 
  end
end
