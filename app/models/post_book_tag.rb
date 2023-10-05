class PostBookTag < ApplicationRecord
    
    belongs_to :book
    belongs_to :book_tag
end
