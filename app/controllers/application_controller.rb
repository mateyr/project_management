# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate_user!, unless: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.html { redirect_to authenticated_root_path, notice: exception.message, status: :not_found }
      format.turbo_stream do
        flash.now[:notice] = exception.message
        render turbo_stream: turbo_stream.prepend(:flash, partial: "shared/flash")
      end
    end
  end
end
