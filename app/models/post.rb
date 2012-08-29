class Post < ActiveRecord::Base
  has_many :posts
  belongs_to :post
  belongs_to :board
  attr_accessible :comment, :email, :name, :password, :photo, :photo_cache
  mount_uploader :photo, PhotoUploader

  scope :toplevel, where("post_id IS ?", nil)
end
