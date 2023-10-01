class Book < ApplicationRecord
  
  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  
  
  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end
  
  validates :title,presence:true
  validates :body,presence:true,length:{maximum:200}
  
  def Book.search_for(content, method)
    if method == 'perfect_match' #完全一致
      Book.where(title: content)
    elsif method == 'prefix_match' #前方一致
      Book.where('title LIKE?', content + '%')
    elsif method == 'backward_match' #後方一致
      Book.where('title LIKE?', '%' + content)
    else #部分一致
      Book.where('title LIKE?', '%' + content + '%')
    end
  end
  
end
