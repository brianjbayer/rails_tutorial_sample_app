# frozen_string_literal: true

require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end
  test 'unsuccessful edit' do
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
end
