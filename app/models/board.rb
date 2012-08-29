class Board < ActiveRecord::Base
  attr_accessible :title, :slug
  has_many :posts
end
