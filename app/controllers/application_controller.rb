class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  after_action :prepare_unobtrusive_flash
end
