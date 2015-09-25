class Book < ActiveRecord::Base
  has_one :book_borrow
  has_one :user, :through => :book_borrow
end
