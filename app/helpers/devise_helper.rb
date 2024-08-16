# frozen_string_literal: true

module DeviseHelper
  def form_action_details
    sign_in = controller_name == "sessions"
    return { sign_in:, url: session_path(resource_name), submit_text: "Sign in" } if sign_in

    { sign_in:, url: registration_path(resource_name), submit_text: "Sign up" }
  end
end
