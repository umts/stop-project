# frozen_string_literal: true

module CurrentUserHelpers
  def when_current_user_is(user)
    current_user = case user
                   when User, nil then user
                   when Symbol then create(:user, user)
                   end
    sign_in current_user
  end
end
