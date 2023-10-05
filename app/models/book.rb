class Book < ApplicationRecord
  
  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  
  has_many :post_book_tags, dependent: :destroy
  has_many :book_tags, through: :post_book_tags
  
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
  
  def save_workout_tags(tags)
    current_tags = self.book_tags.pluck(:name) unless self.book_tags.nil? # タグが存在していれば、タグの名前を配列として全て取得
    old_tags = current_tags - tags   # 現在取得したタグから送られてきたタグを除いてoldtagとする
    new_tags = tags - current_tags    # 送信されてきたタグから現在存在するタグを除いたタグをnewとする
     
    old_tags.each do |old_name| # 古いタグを消す
      self.book_tags.delete BookTag.find_by(name:old_name)
    end
    
    new_tags.each do |new_name| # 新しいタグを保存
      book_tag = BookTag.find_or_create_by(name:new_name)
      self.book_tags << book_tag
    end
  end
  
  scope :latest, -> {order(created_at: :desc)}  #新しいもの順
  scope :star_count, -> {order(star: :desc)} #星の数が多い順
end
