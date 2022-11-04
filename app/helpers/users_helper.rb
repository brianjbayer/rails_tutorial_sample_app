# frozen_string_literal: true

module UsersHelper
  # Returns the Gravatar for the given user
  # See https://www.learnenough.com/course/ruby_on_rails_tutorial_7th_edition/sign_up/showing_users/a_gravatar_image
  def gravatar_for(user, size: 80)
    gravatar_id  = Digest::MD5.hexdigest(user.email.downcase)
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: user.name, class: 'gravatar')
  end
end
