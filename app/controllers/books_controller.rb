class BooksController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]

  def show
    @book = Book.find(params[:id])
    
    @tag_list = @book.book_tags.pluck(:name).join(',')
    @post_book_tags = @book.book_tags
    @book_comment = BookComment.new
  end

  def index
    @book = Book.new
    #@books = Book.all
    
    if params[:latest]
      @books = Book.latest #新しい順の時
    elsif params[:star_count]
      @books = Book.star_count　#星の数が多い順の時
    else
      @books = Book.all #それ以外の時
    end
        
      
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
     # 受け取った値を,で区切って配列にする
    tag_list = params[:book][:name].split(',')
    if @book.save
       @book.save_book_tags(tag_list)
      redirect_to book_path(@book), notice: "You have created book successfully." 
    else
      @books = Book.all
      render 'index'
    end
  end

  def edit
  end

  def update
    @book = Book.find(params[:id])
    tag_list=params[:post_workout][:name].split(',')
    if @book.update(book_params)
       @book.save_book_tags(tag_list)
      redirect_to book_path(@book), notice: "You have updated book successfully." 
    else
      render "edit"
    end
  end

  def destroy
    @book.destroy
    redirect_to books_path
  end

  def search_tag
     @tag_list = BookTag.all
     @tag = BookTag.find(params[:book_tag_id])
     @books = @tag.books
  end


  private

  def book_params
    params.require(:book).permit(:title, :body, :star)
  end
  
  def ensure_correct_user
    @book = Book.find(params[:id])
    @tag_list = @book.book_tags.pluck(:name).join(',')
    unless @book.user == current_user
    redirect_to books_path
    end
  end
end
