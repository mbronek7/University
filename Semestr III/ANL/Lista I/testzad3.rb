require_relative 'zad3.rb'
require 'test/unit'

class TestCalcPi < Test::Unit::TestCase
    def test_499989
        assert_equal(Math::PI,picalc(499989))
    end
    def test_499999
        assert_equal(Math::PI,picalc(499999))
    end
    def test_500000
        assert_equal(Math::PI,picalc(500000))
    end
    def test_510000
        assert_equal(Math::PI,picalc(510000))
    end
    def test_550000
        assert_equal(Math::PI,picalc(550000))
    end
    def test_600000
        assert_equal(Math::PI,picalc(600000))
    end
    def test_900000
        assert_equal(Math::PI,picalc(900000))
    end

end 

