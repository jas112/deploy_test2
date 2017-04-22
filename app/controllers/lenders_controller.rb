class LendersController < ApplicationController

  before_action :user_authorization, except: [:create]

  def new
  end

  def create
    if params[:lender][:password] == params[:lender][:password_confirmation]
      @lender = Lender.new(lender_params)
      if @lender.save
        redirect_to "/"
      else
        flash[:errors] = @lender.errors.full_messages
        redirect_to "/register"
      end
    else
      flash[:errors] = @lender.errors.full_messages
      redirect_to "/"
    end
  end

  def show
    @lender = Lender.find(params[:id])
    @borrowers = Borrower.all
    @my_loans = @lender.loans.joins(:borrower)
    render layout: "three_column"
  end

  def edit
    @lender = Lender.find(params[:id])
  end

  def update
    @lender = Lender.find(params[:id])
    if @lender.update user_params
      redirect_to "/lender/#{@lender.id}"
    else
      flash[:errors] = @user.errors.full_messages
      redirect_to "/lender/#{@lender.id}"
    end
  end

  def destroy
    @lender = Lender.find(params[:id])
    if @lender.destroy
      reset_session
      redirect_to "/"
    end
  end

  private

  def lender_params
    params.require(:lender).permit(:first_name, :last_name, :email, :password, :password_confirmation, :account_balance)
  end

end
