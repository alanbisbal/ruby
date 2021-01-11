class Book < ApplicationRecord
  belongs_to :user

  has_many :notes, inverse_of: :book

  validates_uniqueness_of :title, presence:true, scope: :user_id, length: {maximum:255 }

  def to_s
    title
  end

end
