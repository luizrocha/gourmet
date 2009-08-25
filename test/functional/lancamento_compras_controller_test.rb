require 'test_helper'

class LancamentosControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:lancamentos)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create lancamento" do
    assert_difference('Lancamento.count') do
      post :create, :lancamento => { }
    end

    assert_redirected_to lancamento_path(assigns(:lancamento))
  end

  test "should show lancamento" do
    get :show, :id => lancamentos(:one).id
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => lancamentos(:one).id
    assert_response :success
  end

  test "should update lancamento" do
    put :update, :id => lancamentos(:one).id, :lancamento => { }
    assert_redirected_to lancamento_path(assigns(:lancamento))
  end

  test "should destroy lancamento" do
    assert_difference('Lancamento.count', -1) do
      delete :destroy, :id => lancamentos(:one).id
    end

    assert_redirected_to lancamentos_path
  end
end
