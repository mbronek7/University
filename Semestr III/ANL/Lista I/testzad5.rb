require_relative 'zad5'
require 'test/unit'

class TestNaturalLogarithmFunction < Test::Unit::TestCase
    def test_with_precision_of_1
        assert_equal(Math.log(2).truncate(1),ln(2).truncate(1))
        assert_equal(Math.log(3).truncate(1),ln(3).truncate(1))
        assert_equal(Math.log(4).truncate(1),ln(4).truncate(1))
        assert_equal(Math.log(5).truncate(1),ln(5).truncate(1))
        assert_equal(Math.log(10).truncate(1),ln(10).truncate(1))
        assert_equal(Math.log(90).truncate(1),ln(90).truncate(1))
        assert_equal(Math.log(200).truncate(1),ln(200).truncate(1))
    end
    def test_with_precision_of_2
        assert_equal(Math.log(2).truncate(2),ln(2).truncate(2))
        assert_equal(Math.log(3).truncate(2),ln(3).truncate(2))
        assert_equal(Math.log(4).truncate(2),ln(4).truncate(2))
        assert_equal(Math.log(5).truncate(2),ln(5).truncate(2))
        assert_equal(Math.log(10).truncate(2),ln(10).truncate(2))
        assert_equal(Math.log(90).truncate(2),ln(90).truncate(2))
        assert_equal(Math.log(200).truncate(1),ln(200).truncate(1))
    end
    def test_with_precision_of_5
        assert_equal(Math.log(2).truncate(5),ln(2).truncate(5))
        assert_equal(Math.log(3).truncate(5),ln(3).truncate(5))
        assert_equal(Math.log(4).truncate(5),ln(4).truncate(5))
        assert_equal(Math.log(5).truncate(5),ln(5).truncate(5))
        assert_equal(Math.log(10).truncate(5),ln(10).truncate(5))
        assert_equal(Math.log(90).truncate(5),ln(90).truncate(5))
    end
end 
