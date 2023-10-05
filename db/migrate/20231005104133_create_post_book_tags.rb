class CreatePostBookTags < ActiveRecord::Migration[6.1]
  def change
    create_table :post_book_tags do |t|

      t.references :book, null: false, foreign_key: true
      t.references :book_tag, null: false, foreign_key: true
      
      t.timestamps
    end
    
     #同じタグは２回保存できない
      add_index :post_book_tags, [:book_id,:book_tag_id],unique: true
  end
end
