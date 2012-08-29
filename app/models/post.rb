class Post < ActiveRecord::Base
  belongs_to :post
  belongs_to :board
  attr_accessible :comment, :email, :name, :password, :photo, :photo_cache
  mount_uploader :photo, PhotoUploader
end
