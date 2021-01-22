require 'minitest/autorun'
require './lib/bowling'

class BowlingTest < Minitest::Test
  def test_main
    assert_equal 139, main('6390038273X9180X645')
    assert_equal 164, main('6390038273X9180XXXX')
    assert_equal 107, main('0X150000XXX518104')
    assert_equal 134, main('6390038273X9180XX00')
    assert_equal 300, main('XXXXXXXXXXXX')
  end
end
