class User < ApplicationRecord

  REQUIRED_CSV_COLUMNS = [:name, :password]

  validates :name, presence: true

end