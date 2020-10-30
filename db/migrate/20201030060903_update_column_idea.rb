class UpdateColumnIdea < ActiveRecord::Migration[6.0]
  def change
    add_index :ideas, :author, unique: true
  end
end
