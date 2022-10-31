require "test_helper"

class UsersHelperTest < ActionView::TestCase

  def setup
    @user_name = 'Foo Bar'
    email = 'Foo@bar.com'
    @gravatar_id = Digest::MD5::hexdigest(email.downcase)
    @user = User.new(name: @user_name, email: email)
  end

  test 'gravatar for alt text' do
    assert_match /alt=\"#{@user_name}\"/, gravatar_for(@user)
  end

  test 'gravatar for gravatar url default size' do
    gravatar_url = "https://secure.gravatar.com/avatar/#{@gravatar_id}?s=80"
    assert_match /src=\"#{Regexp.escape(gravatar_url)}\"/, gravatar_for(@user)
  end

  test 'gravatar for gravatar url specified size' do
    size = 63
    gravatar_url = "https://secure.gravatar.com/avatar/#{@gravatar_id}?s=#{size}"
    assert_match /src=\"#{Regexp.escape(gravatar_url)}\"/, gravatar_for(@user, size: size)
  end
end
