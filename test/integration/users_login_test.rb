# frozen_string_literal: true

require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end

  test 'login with valid email/invalid password' do
    get login_path
    assert_template 'sessions/new'
    post login_path params: { session: { email: @user.email,
                                         password: '' } }
    assert_response :unprocessable_entity
    assert_template 'sessions/new'
    assert_not_empty flash
    get root_path
    assert_empty flash
  end

  test 'login with invalid email/valid password' do
    get login_path
    assert_template 'sessions/new'
    post login_path params: { session: { email: '',
                                         password: 'password' } }
    assert_response :unprocessable_entity
    assert_template 'sessions/new'
    assert_not_empty flash
    get root_path
    assert_empty flash
  end

  test 'login with valid information' do
    post login_path, params: { session: { email: @user.email,
                                          password: 'password' } }
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    # Log in link should not be on the page
    assert_select 'a[href=?]', login_path, count: 0
    assert_select 'a[href=?]', logout_path
    assert_select 'a[href=?]', user_path(@user)
  end
end
