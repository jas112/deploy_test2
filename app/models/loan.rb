class Loan < ActiveRecord::Base
  belongs_to :lender
  belongs_to :borrower

  validates :amount, :lender_id, :borrower_id, :presence => true

end
