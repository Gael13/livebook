require 'rails_helper'


RSpec.describe Book, :type => :model do

  it "has 0 Book at the beginning" do
    expect(Book.count).to eq 0
  end

  it "has 1 Book after adding one" do
    bo = FactoryGirl.create :book
    expect(Book.count).to eq 1
  end

  it "title" do
    expect(Book.new).to respond_to(:title)
  end

  it "author" do
    expect(Book.new).to respond_to(:author)
  end

end