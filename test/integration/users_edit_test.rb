# frozen_string_literal: true

require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end
  test 'unsuccessful edit' do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    expected_err_count = 4
    patch user_path(@user), params: { user: { name: '',
                                              email: 'foo@invalid',
                                              password: 'foo',
                                              password_confirmation: 'bar' } }
    assert_template 'users/edit'
    assert_select 'div.alert.alert-danger', /#{expected_err_count} errors/
  end

  test 'successful edit with friendly forwarding' do
    get edit_user_path(@user)
    assert_not_nil session[:forwarding_url]
    log_in_as(@user)
    assert_redirected_to edit_user_url(@user)
    name = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@user), params: { user: { name: name,
                                              email: email,
                                              password: '',
                                              password_confirmation: '' } }
    assert_redirected_to @user
    follow_redirect!
    assert_not_empty flash
    assert_select 'div.alert.alert-success'
    assert_nil session[:forwarding_url]
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email
  end
end
