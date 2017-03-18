class Audio < ActiveRecord::Base
  include ServerPush

  attr_accessor :url, :video_id

  has_many :taggings
  has_many :tags, through: :taggings
  has_many :comments

  validates :source, :embed_code, presence: true, allow_blank: false

  def public_attributes
    attributes
  end

  before_validation :set_embed_code
  def set_embed_code
    instance_eval &(EmbedUrl.build(self.source, self.url, self.video_id))
  rescue JSON::ParserError => e
    self.errors.add :base, "not a valid url or video id"
    throw :abort
  rescue OpenURI::HTTPError => e
    self.errors.add :base, "not a valid url or video id"
    throw :abort
  end
  
end

class Tagging < ActiveRecord::Base
  include ServerPush

  validates :audio, :tag, presence: true, allow_blank: false
  validates_uniqueness_of :audio, scope: [:tag]

  belongs_to :audio
  belongs_to :tag

  attr_accessor :name

  def public_attributes
    attributes
  end

  before_validation :ensure_tag_exists
  def ensure_tag_exists
    unless self.name&.length > 0
      errors.add :base, "cant create empty tag"
      throw :abort
    end
    self.tag_id = Tag.find_or_create_by(name: self.name).id
  end

  before_destroy :remove_tag_if_no_taggings
  def remove_tag_if_no_taggings
    tag.destroy if tag.taggings.count == 1
  end

end

class Tag < ActiveRecord::Base

  include ServerPush

  has_many :taggings
  has_many :audios, through: :taggings

  validates :name, presence: true

  def public_attributes
    attributes
  end

end

class Comment < ActiveRecord::Base
  include ServerPush

  validates :audio, :content, presence: true, allow_blank: false

  belongs_to :audio

  # There is a secret admin-only hook to delete audios by adding a special comment.
  before_validation :admin_destroy_audio_hook
  def admin_destroy_audio_hook
    return unless [self.content, self.audio].none? &:blank?
    if self.content == ENV['ADMIN_DESTROY_AUDIO_PASSWORD']
      self.audio.taggings.each &:destroy
      self.audio.comments.each &:destroy
      self.audio.destroy
      self.errors.add :base, "destroyed audio"
      throw :abort
    end
  end

  def public_attributes
    attributes
  end
end
