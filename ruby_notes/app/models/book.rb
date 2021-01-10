class Book < ApplicationRecord
  belongs_to :user

  has_many :notes, inverse_of: :book

  validates :title, presence:true, uniqueness:true, length: {maximum:255 }

  def to_s
    title
  end

end
