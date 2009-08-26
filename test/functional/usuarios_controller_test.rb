require 'test_helper'

class UsuariosControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:usuarios)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create usuario" do
    assert_difference('Usuario.count') do
      post :create, :usuario => { }
    end

    assert_redirected_to usuario_path(assigns(:usuario))
  end

  test "should show usuario" do
    get :show, :id => usuarios(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => usuarios(:one).id
    assert_response :success
  end

  test "should update usuario" do
    put :update, :id => usuarios(:one).id, :usuario => { }
    assert_redirected_to usuario_path(assigns(:usuario))
  end

  test "should destroy usuario" do
    assert_difference('Usuario.count', -1) do
      delete :destroy, :id => usuarios(:one).id
    end

    assert_redirected_to usuarios_path
  end
end
