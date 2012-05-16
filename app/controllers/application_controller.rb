class ApplicationController < ActionController::Base
  protect_from_forgery

  if Rails.env == "development"
    http_basic_authenticate_with :name => "b", :password => "m"
  end
end
