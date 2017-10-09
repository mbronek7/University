require_relative 'zad3.rb'
require 'test/unit'

class TestCalcPi < Test::Unit::TestCase
    def test_4999998
        assert_same((Math::PI-picalc(4999998)).abs < 2 * 10**(-7),true,"działa")
    end
    def test_4999999
        assert_same((Math::PI-picalc(4999999)).abs < 2 * 10**(-7),true,"działa")
    end
    def test_5000000
        assert_same((Math::PI-picalc(5000000)).abs < 2 * 10**(-7),true,"działa")
    end
    def test_5000001
        assert_same((Math::PI-picalc(5000001)).abs < 2 * 10**(-7),true,"działa")
    end
    def test_5000002
        assert_same((Math::PI-picalc(5000002)).abs < 2 * 10**(-7),true,"działa")
    end
end 

