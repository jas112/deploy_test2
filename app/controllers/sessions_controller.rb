class SessionsController < ApplicationController
  def new
    render layout: "three_column"
  end

  def register
    render layout: "two_column"
  end

  def create #Log User in with authenticate -- generates flash messages errors
    if Lender.exists?(email: params[:user][:email])
      @user = Lender.find_by_email(params[:user][:email])
      if @user && @user.authenticate(params[:user][:password])
        session[:user_id] = @user.id
        session[:user_email] = @user.email
        redirect_to "/lender/#{@user.id}"
      else
      flash[:errors] = ["Invalid Combination"]
      redirect_to "/"
      end
    else
      if Borrower.exists?(email: params[:user][:email])
        @user = Borrower.find_by_email(params[:user][:email])
        if @user && @user.authenticate(params[:user][:password])
          session[:user_id] = @user.id
          session[:user_email] = @user.email
          redirect_to "/borrower/#{@user.id}"
        else
        flash[:errors] = ["Invalid Combination"]
        redirect_to "/"
        end
      end
    end
    # else
    #   @borrower = Borrower.find_by_email(params[:email])
    #   if @borrower && @borrower.authenticate(params[:password])
    #     session[:borrower_id] = @borrower.id
    #     redirect_to "/borrower/#{@borrower.id}"
    #   else
    #     flash[:errors] = ["Invalid Combination"]
    #     redirect_to "/"
    #   end
    # end
  end

  def destroy #Logs User out -- sets session[:user_id] to null -- redirects to login page
    reset_session
    redirect_to "/"
  end

end
