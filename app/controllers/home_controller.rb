class HomeController < ApplicationController
  include ActionView::Helpers::SanitizeHelper
  
  before_action :set_book, only: [:edit_book, :update_book, :destroy_book, :borrow_book, :give_back]

  def index
    @books = Book.where(owner_id: current_user.id)
    @books_b = BookBorrow.where(user_id: current_user.id)
    @books_l = BookBorrow.where.not(user_id: current_user.id)
    @users = User.where.not(id: current_user.id)
  end

  def new_book
    @book = Book.new
  end

  def edit_book
  end

  def create_book
    @book = Book.new(book_params)

    respond_to do |format|
      if @book.save
        format.html { redirect_to root_url }
        gflash :success => "The book is successfully created"
        format.json { render :show, status: :created, location: @book }
      else
        format.html { render :new }
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end

  def update_book
    @book.title = sanitize(params[:book][:title], :tags=>[])
    @book.author = sanitize(params[:book][:author], :tags=>[])

    respond_to do |format|
      if @book.save
        format.html { redirect_to root_url }
        gflash :success => "The book is successfully updated"
        format.json { render :index, status: :ok, location: @book }
      else
        format.html { render :edit }
        gflash :error => "The book wasn't updated"
        format.json { render json: @book.errors, status: :unprocessable_entity }
      end
    end
  end


  def destroy_book
    @book.destroy
    respond_to do |format|
      format.html { redirect_to root_url }
      gflash :success => t("gflash.titles.delete_book")
      format.json { head :no_content }
    end
  end

  def borrow_book
    @book_b = BookBorrow.find_or_create_by(book_id: @book.id)
  	@book_b.user_id = params[:borrow_book][:user_id]
    @book_b.save!

    respond_to do |format|
        format.js
    end
  end

  def give_back
  	@book_borrowed = BookBorrow.where(book_id: @book.id, user_id: current_user.id).first
    logger.info("===> #{@book_borrowed.to_json}")
    @book_borrowed.destroy
    respond_to do |format|
        format.js
    end
  end

  private

    def set_book
      @book = Book.find(params[:id])
    end

    def book_params
      params.require(:book).permit(:title, :author, :owner_id, :borrower_id)
    end
end
