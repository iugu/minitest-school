class ApplicationController < ActionController::Base
  protect_from_forgery

  def apc_method
    "OKIE DOKIE"
  end
end
