require_dependency 'file_size_validator'
require_dependency 'rc4'
class Post < ActiveRecord::Base
  has_many :posts, dependent: :destroy
  belongs_to :post
  belongs_to :board
  attr_accessible :comment, :emailp, :name, :password, :photo, :photo_cache, :subject
  mount_uploader :photo, PhotoUploader
  validates :photo,
    :file_size => {
      :maximum => 5.megabytes.to_i
    }

  validates :name, length: { maximum: KATSUNI_MAX_FIELD_LENGTH },
    format: { with: /\A[^\n\r]*\z/ }
  validates :email, length: { maximum: KATSUNI_MAX_FIELD_LENGTH },
    format: { with: /\A[^\n\r]*\z/ }
  validates :subject, length: { maximum: KATSUNI_MAX_FIELD_LENGTH },
    format: { with: /\A[^\n\r]*\z/ }
  validates :comment, length: { maximum: KATSUNI_MAX_COMMENT_LENGTH }
  scope :toplevel, where("post_id IS ?", nil).order("updated_at DESC")
  scope :reply_order, order("created_at ASC")

  before_create :process_name
  before_create :process_sage
  validate :toplevel_post_has_photo

  attr_reader :emailp
  def emailp=(value)
    if value =~ /sage/
      @sage = true
    else
      self.email = value
    end
  end

  def sage?
    @sage || false
  end

  def toplevel_post_has_photo
    if post.blank? && !photo?
      self.errors[:photo] << "Photo must be present." # todo: translate
    end
  end

  def process_sage
    if self.post.present? && !sage?
      if self.post.posts.count < KATSUNI_MAX_RES # todo: fix if more than one ppl sage
        self.post.touch
      end
    end
  end

  def get_tripcode
    require 'digest/md5'
    if name =~ /^(.*?)((?<!&)#|#{Regexp.escape(KATSUNI_TRIPKEY)})(.*)$/
      namepart, marker, trippart = $1, $2, $3
      trip = ''
      marker = Regexp.escape(marker)
      if KATSUNI_SECRET.present? &&
        trippart.sub!(/(?:#{marker})(?<!&#)(?:#{marker})*(.*)$/, '')
        trip = KATSUNI_TRIPKEY * 2 +
          RC4::hide_data($1, 6, "trip", KATSUNI_SECRET, true)
        return [namepart, trip] if trippart.blank?
      end

      salt = (trippart + "H..").slice(1,2)
      salt.gsub!(/[^\.-z]/, ".")
      from = ":;<=>?@[\\]^_`"
      to = "ABCDEFGabcdef".each_char.to_a
      from_to = Hash[from.each_char.map { |c| [c, to.shift] }]
      salt.gsub!(from, from_to)
      digest = Digest::MD5.hexdigest(trippart + salt).to_s
      trip = KATSUNI_TRIPKEY + digest[-10, digest.length] + trip

      [namepart, trip]
    else
      [name, nil]
    end
  end

  def process_name
    self.name = name.strip

    # tripcode
    namepart, trip = get_tripcode
    self.name = "#{namepart}#{trip}"
  end
end
