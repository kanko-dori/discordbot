class UpdateIdeasUniqueName < ActiveRecord::Migration[6.0]
  def change
    remove_index :ideas, column: :author
    add_index :ideas, :name, unique: true
  end
end
