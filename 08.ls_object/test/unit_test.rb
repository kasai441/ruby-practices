#!/usr/bin/env ruby
# frozen_string_literal: true

require 'minitest/autorun'

require './lib/unit'

class UnitTest < Minitest::Test
  def setup
    @unit = Unit.new('sample')
  end

  def test_display
    @unit.add_tab(2)
    assert_equal("sample\t\t", @unit.display)
  end

  def test_need_tab
    assert_equal(2, @unit.need_tab(22))
    assert_equal(3, @unit.need_tab(23))
  end
end
