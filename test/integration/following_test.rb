# frozen_string_literal: true

require 'test_helper'

class Following < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    log_in_as(@user)
  end
end

class FollowingTest < Following
  test 'following page' do
    get following_user_path(@user)
    assert_response :unprocessable_entity
    assert_not @user.following.empty?
    assert_match @user.following.count.to_s, response.body
    @user.following.each do |user|
      # There should be 3 links: sidebar gravatar, user name and gravatar
      assert_select 'a[href=?]', user_path(user), count: 3
    end
  end

  test 'followers page' do
    get followers_user_path(@user)
    assert_response :unprocessable_entity
    assert_not @user.followers.empty?
    assert_match @user.followers.count.to_s, response.body
    @user.followers.each do |user|
      # There should be 3 links: sidebar gravatar, user name and gravatar
      assert_select 'a[href=?]', user_path(user), count: 3
    end
  end
end