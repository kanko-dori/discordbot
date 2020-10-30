class AddColumnIdea < ActiveRecord::Migration[6.0]
  def change
    add_column :ideas, :author, :string
  end
end
