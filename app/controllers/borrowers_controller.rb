class BorrowersController < ApplicationController

  before_action :user_authorization, except: [:create]

  def create
    if params[:borrower][:password] == params[:borrower][:password_confirmation]
      @borrower = Borrower.new(borrower_params)
      @borrower.ammount_raised = 0
      if @borrower.save
        redirect_to "/"
      else
        flash[:errors] = @borrower.errors.full_messages
        redirect_to "/register"
      end
    else
      flash[:errors] = @borrower.errors.full_messages
      redirect_to "/"
    end
  end

  def show
    @borrower = Borrower.find(current_user.id)
    render layout: "three_column"
  end

  private

  def borrower_params
    params.require(:borrower).permit(:first_name, :last_name, :email, :password, :password_confirmation, :loan_reason, :loan_description, :ammount_needed, :ammount_raised)
  end

end
