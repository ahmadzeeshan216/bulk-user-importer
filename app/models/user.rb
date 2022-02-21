class User < ApplicationRecord
  include PasswordValidator

  REQUIRED_CSV_COLUMNS = [:name, :password]

  validates :name, presence: true

end