class User < ApplicationRecord

  has_many :books, inverse_of: :user
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  after_create :create_book

  def create_book
       self.books.create(title: "Global",user_id: self.id)
  end
end
