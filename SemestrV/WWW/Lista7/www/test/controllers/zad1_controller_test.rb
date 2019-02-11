require 'test_helper'

class Zad1ControllerTest < ActionDispatch::IntegrationTest
  test "should get typ1" do
    get zad1_typ1_url
    assert_response :success
  end

  test "should get typ2" do
    get zad1_typ2_url
    assert_response :success
  end

  test "should get typ3" do
    get zad1_typ3_url
    assert_response :success
  end

  test "should get typ4" do
    get zad1_typ4_url
    assert_response :success
  end

end
