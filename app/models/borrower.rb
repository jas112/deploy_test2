class Borrower < ActiveRecord::Base

  has_secure_password

  has_many :loans
  has_many :lenders, through: :loans

  EMAIL_REGEX = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]+)\z/i
  validates :first_name, :last_name, :password, :password_confirmation, :loan_reason, :loan_description, :ammount_needed, :presence => true, on: [:create]
  validates :email, presence: true, uniqueness: { case_sensitive: false }, format: { with: EMAIL_REGEX }, on: [:create]

  before_save :downcase_email

  private
  def downcase_email
    email.downcase! if email.present?
  end

end
