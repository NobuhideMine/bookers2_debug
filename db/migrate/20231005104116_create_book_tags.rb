class CreateBookTags < ActiveRecord::Migration[6.1]
  def change
    create_table :book_tags do |t|
      
       t.string :name, null: false
      
      t.timestamps
    end
    
    add_index :book_tags, :name, unique:true 
  end
end
