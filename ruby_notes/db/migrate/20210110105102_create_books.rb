class CreateBooks < ActiveRecord::Migration[6.1]
  def change
    create_table :books do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.string :title, null:false

      t.timestamps
    end
    add_index :books, [:title, :user_id], unique: true
  end
end
