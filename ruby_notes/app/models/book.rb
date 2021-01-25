class Book < ApplicationRecord
  belongs_to :user

  has_many :notes, inverse_of: :book, dependent: :delete_all

  validates_uniqueness_of :title, presence:true, scope: :user_id, length: {maximum:255 }

  def to_s
    title
  end

  def containNote(id)
    ok = false
    if self.notes.exists? (id)
      return true
    end
    ok
  end

  def exportAll
    for note in self.notes
      note.export
    end
  end

end
