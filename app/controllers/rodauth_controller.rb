class RodauthController < ApplicationController
  layout :rodauth_layout

  private

  def rodauth_layout
    case request.path
    when rodauth.login_path,
         rodauth.create_account_path,
         rodauth.verify_account_path,
         rodauth.verify_account_resend_path,
         rodauth.reset_password_path,
         rodauth.reset_password_request_path
      "rodauth"
    else
      "dashboard"
    end
  end
end
