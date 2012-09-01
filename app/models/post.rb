require_dependency 'file_size_validator'
class Post < ActiveRecord::Base
  has_many :posts, dependent: :destroy
  belongs_to :post
  belongs_to :board
  attr_accessible :comment, :email, :name, :password, :photo, :photo_cache, :subject
  mount_uploader :photo, PhotoUploader
  validates :photo,
    :file_size => {
      :maximum => 5.megabytes.to_i
    }

  validates :name, length: { maximum: 100 }, format: { with: /\A[^\n\r]*\z/ }
  validates :email, length: { maximum: 100 }, format: { with: /\A[^\n\r]*\z/ }
  validates :subject, length: { maximum: 100 }, format: { with: /\A[^\n\r]*\z/ }
  scope :toplevel, where("post_id IS ?", nil).order("updated_at DESC")
  scope :reply_order, order("created_at ASC")

  before_create :process_name
  before_create :process_sage
  validate :toplevel_post_has_photo

  def toplevel_post_has_photo
    if post.blank? && !photo?
      self.errors[:photo] << "Photo must be present." # todo: translate
    end
  end

  def process_sage
    if self.post.present? && !(email =~ /sage/)
      if self.post.posts.count < KATSUNI_MAX_RES # todo: fix if more than one ppl sage
        self.post.touch
      end
    end
  end

  def process_name
    self.name = name.strip.gsub(/[\n\r]/, "")

    # tripcode
    if name =~ /(#|!)(.*)/
      cap = $2
      cap2 = cap + "H."
      salt = cap2[1,2]
      salt.gsub!(/[^\.-z]/,".")
      from = ":;<=>?@[\\]^_`"
      to = "ABCDEFGabcdef".each_char.to_a
      from_to = Hash[from.each_char.map { |c| [c, to.shift] }]
      salt.gsub!(from, from_to)
      require 'digest/md5'
      digest = Digest::MD5.hexdigest(cap + salt).to_s
      name.gsub!(/(#|!)(.*)/,"")
      self.name += KATSUNI_TRIPKEY + digest[-10, 10]
    end
  end

  def name
    # todo: fix
    if self[:name].blank?
      "Anonymous"
    else
      self[:name]
    end
  end
end
