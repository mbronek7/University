require_relative 'zad6'
require 'test/unit'

class TestFATanFuntioc < Test::Unit::TestCase
    def test_all
        assert_equal(Math.atan(3),FATan(3))
        assert_equal(Math.atan(-2),FATan(-2))
        assert_equal(Math.atan(-223),FATan(-223))
        assert_equal(Math.atan(-2.5),FATan(-2.5))
        assert_equal(Math.atan(222),FATan(222))
        assert_equal(Math.atan(999),FATan(999))
        assert_equal(Math.atan(441),FATan(441))
        assert_equal(Math.atan(5000),FATan(5000))
    end
end 
