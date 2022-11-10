# frozen_string_literal: true

require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end
  test 'should get new' do
    get signup_path
    assert_response :success
    assert_select 'title', full_title('Sign up')
  end

  test 'should redirect edit when not logged in' do
    get edit_user_path(@user)
    assert_not_empty flash
    assert_redirected_to login_url
  end

  test 'should redirect update when not logged in' do
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }
    get edit_user_path(@user)
    assert_not_empty flash
    assert_redirected_to login_url
  end
end
