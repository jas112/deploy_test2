class LoansController < ApplicationController
  def create
    @borrower = Borrower.find(params[:id])
    @lender = Lender.find(current_user.id)
    if @borrower.lenders.include?(current_user)
      loan_addition = params[:loan][:amount]
      @loan = Loan.where(borrower: @borrower, lender: @lender).first
      if loan_addition.to_i <= @lender.account_balance
        increased_loan_amount = @loan.amount + loan_addition.to_i
        raised_amount = @borrower.ammount_raised + loan_addition.to_i
        @borrower.update(ammount_raised: raised_amount)
        new_balance = @lender.account_balance - loan_addition.to_i
        @lender.update(account_balance: new_balance)
        @loan.update(amount: increased_loan_amount)
        redirect_to "/lender/#{@lender.id}"
      end
    else
      @loan = Loan.new(loan_params)
      if @loan.amount.to_i <= @lender.account_balance
        raised_amount = @borrower.ammount_raised + @loan.amount.to_i
        @borrower.update(ammount_raised: raised_amount)
        new_balance = @lender.account_balance -= @loan.amount.to_i
        @lender.update(account_balance: new_balance)
        if @loan.save
          redirect_to "/lender/#{@lender.id}"
        else
          flash[:errors] = @loan.errors.full_messages
          redirect_to "/lender/#{@lender.id}"
        end
      else
        flash[:errors] = "Loan Amount is greater than available balance."
        redirect_to "/lender/#{@lender.id}"
      end
    end
  end

  private
  def loan_params
    params.require(:loan).permit(:amount, :borrower_id).merge(lender: current_user)
  end

end
