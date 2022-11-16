# frozen_string_literal: true

require 'test_helper'

class UsersSignup < ActionDispatch::IntegrationTest

  def setup
    # Clear out any emails
    ActionMailer::Base.deliveries.clear
  end
end

class UsersSignupTest < UsersSignup
  test 'invalid signup information' do
    get signup_path
    expected_err_count = 4
    assert_no_difference 'User.count' do
      post users_path, params: { user: { name: '',
                                         email: 'user@invalid',
                                         password: 'foo',
                                         password_confirmation: 'bar' } }
    end
    assert_response :unprocessable_entity
    assert_template 'users/new'
    assert_select 'div#error_explanation' do
      assert_select 'div.alert.alert-danger', /#{expected_err_count} errors/
      assert_select 'ul>li', expected_err_count
      # e.g. Name can't be blank
      assert_select 'ul>li', /name.+blank/i
      # e.g. Email is invalid
      assert_select 'ul>li', /email.+invalid/i
      # Password confirmation doesn't match Password
      assert_select 'ul>li', /confirmation.+match/i
      # Password is too short (minimum is 6 characters)
      assert_select 'ul>li', /Password.+minimum/i
    end
    # Both the label and inputs should be wrapped in div.field_with_errors
    assert_select 'div.field_with_errors', (2 * expected_err_count)
  end

  test 'valid signup information with account activation' do
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name: 'Example User',
                                         email: 'user@example.com',
                                         password: 'password',
                                         password_confirmation: 'password' } }
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
  end
end

class AccountActivationTest < UsersSignup
  def setup
    super
    post users_path, params: { user: { name: 'Example User',
                                       email: 'user@example.com',
                                       password: 'password',
                                       password_confirmation: 'password' } }
    @user = assigns(:user)
  end

  test 'should not be activated' do
    assert_not @user.activated?
  end

  test 'should not be able to log in before activation' do
    log_in_as(@user)
    assert_not is_logged_in?
  end

  test 'should not be able to log in with invalid activation token' do
    get edit_account_activation_path('invalid token', email: @user.email)
    assert_not is_logged_in?
  end

  test 'should not be able to log in with invalid email' do
    get edit_account_activation_path(@user.activation_token, email: 'invalid email')
    assert_not is_logged_in?
  end

  test 'should log in successfully with valid activation token and email' do
    get edit_account_activation_path(@user.activation_token, email: @user.email)
    assert @user.reload.activated?
    follow_redirect!
    assert_template 'users/show'
    assert_not_empty flash
    assert_select 'div.alert.alert-success'
    assert is_logged_in?
  end
end
