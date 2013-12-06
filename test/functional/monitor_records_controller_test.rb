require 'test_helper'

class MonitorRecordsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:monitor_records)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create monitor_record" do
    assert_difference('MonitorRecord.count') do
      post :create, :monitor_record => { }
    end

    assert_redirected_to monitor_record_path(assigns(:monitor_record))
  end

  test "should show monitor_record" do
    get :show, :id => monitor_records(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => monitor_records(:one).to_param
    assert_response :success
  end

  test "should update monitor_record" do
    put :update, :id => monitor_records(:one).to_param, :monitor_record => { }
    assert_redirected_to monitor_record_path(assigns(:monitor_record))
  end

  test "should destroy monitor_record" do
    assert_difference('MonitorRecord.count', -1) do
      delete :destroy, :id => monitor_records(:one).to_param
    end

    assert_redirected_to monitor_records_path
  end
end
