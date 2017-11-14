require_relative 'zad3.rb'
require 'test/unit'

class TestCalcPi < Test::Unit::TestCase
    def test_20000000
        assert_same((Math::PI-picalc(20000000)).abs <  10**(-7),true,"działa")
    end
    def test_10000000
        assert_same((Math::PI-picalc(10000000)).abs <  10**(-7),true,"działa")
    end
end 

