# frozen_string_literal: true

module CurrentUserHelpers
  def when_current_user_is(user)
    sign_in case user
            when User, nil then user
            when :anyone, :anybody then create :user
            when Symbol then create :user, user
            end
  end
end
