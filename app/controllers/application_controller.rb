class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :require_login, except: [:new, :create, :register]

  def current_user
    if Lender.where(email: session[:user_email]).first
      Lender.where(email: session[:user_email]).first if session[:user_email]
    else
      Borrower.where(email: session[:user_email]).first if session[:user_email]
    end
  end

  helper_method :current_user

  private
  def require_login
    unless logged_in
      flash[:error] = "You must be logged in to access this section"
      redirect_to "/"
    end
  end

  def logged_in
    !!current_user
  end

  def user_authorization
    if Lender.where(email: session[:user_email]).first
      @user = Lender.find(params[:id])
      redirect_to "/lender/#{current_user.id}" unless current_user === @user
    else
      @user = Borrower.find(params[:id])
      redirect_to "/borrower/#{current_user.id}" unless current_user === @user
    end
  end

end
