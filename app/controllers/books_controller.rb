class BooksController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  
  def index
    if user_signed_in? && params[:ft] && params[:ft] == 'my'
      if params[:category_ft].present? 
        @books = Book.includes(:user).where("user_id = ? AND category_id = ?", current_user.id, params[:category_ft]).order('updated_at DESC')
      else
        @books = Book.includes(:bookmarks, :reviews, :user).where("user_id = ? ", current_user.id).order('updated_at DESC')
      end
    elsif user_signed_in? && params[:ft] && params[:ft] == 'bookmark'
      if params[:category_ft].present? 
        @books = Book.joins(:bookmarks).where("bookmarks.user_id = ? AND category_id = ?", current_user.id, params[:category_ft]).order('updated_at DESC')
      else
        @books = Book.joins(:bookmarks).where('bookmarks.user_id = ?', current_user.id).order('updated_at DESC')
      end
    else
      if params[:category_ft].present? 
        @books = Book.where('category_id = ?', params[:category_ft]).order('updated_at DESC')
      else
        @books = Book.includes(:bookmarks, :reviews, :user).order('updated_at DESC')
      end
    end
    
    @categories = Category.all

  end
  
  def show 
    @book = Book.find(params[:id])
    if user_signed_in?
      @my_bookmark = @book.bookmarks.select{|s| s.user_id == current_user.id}.first
    end
    if user_signed_in?
      my_review = @book.reviews.select{|s| s.user_id == current_user.id}.first
      unless my_review
        @my_review = Review.new
      end
    end
  end
  
  def new
    @book = Book.new
    @categories = Category.all
  end
  
  def create
    @book = Book.new
    @book.attributes = input_params
    @book.user_id = current_user.id
    if @book.valid?
      @book.save!
      flash[:notice] = I18n.t('book.created')
      redirect_to action: :show, id: @book.id
    else
      @categories = Category.all
      render :new
    end
  end
  
  def edit
    @book = Book.find(params[:id])
    @categories = Category.all
  end
  
  def update
    @book = Book.find(params[:id])
    @book.attributes = input_params
    @book.user_id = current_user.id
    if @book.valid?
      @book.save!
      flash[:notice] = I18n.t('book.updated')
      redirect_to action: :show
    else
      @categories = Category.all
      render :edit
    end
  end
  
  def destroy
    @book = Book.find(params[:id])
    @book.destroy!
    flash[:notice] = I18n.t('book.deleted')
    redirect_to action: :index
  end
     
  private
  def input_params
    params.require(:book).permit(:title, :author, :publisher, :price, :publish_date, :category_id, :caption, :image)
  end
  
end
