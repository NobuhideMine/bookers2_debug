class Book < ApplicationRecord
  
  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  
  has_many :book_tags, dependent: :destroy
  has_many :tags, through: :book_tags
  
  validates :title,presence:true
  validates :body,presence:true,length:{maximum:200}
  
  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end
  
  def save_tags(savebook_tags)
    current_tags = self.tags.pluck(:name) unless self.tags.nil? # タグが存在していれば、タグの名前を配列として全て取得
    old_tags = current_tags - savebook_tags   # 現在取得したタグから送られてきたタグを除いてoldtagとする
    new_tags = savebook_tags - current_tags    # 送信されてきたタグから現在存在するタグを除いたタグをnewとする
     
    old_tags.each do |old_name| # 古いタグを消す
      self.tags.delete Tag.find_by(name:old_name)
    end
    
    new_tags.each do |new_name| # 新しいタグを保存
      book_tag = Tag.find_or_create_by(name:new_name)
      #配列に保存
      self.tags << book_tag
    end
  end
  
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
  #scope :latest, -> {order(created_at: :desc)}  #新しいもの順
  #scope :star_count, -> {order(star: :desc)} #星の数が多い順
end
