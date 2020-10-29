class CreateIdeaTable < ActiveRecord::Migration[6.0]
    def self.up
      create_table :ideas do |t|
        t.string :name
        t.text :description
  
        t.timestamps
      end
    end
    
    def self.down
      delete_table :ideas
    end
  end
  