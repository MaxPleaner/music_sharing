class Audio < ActiveRecord::Base
  include ServerPush

  attr_accessor :url, :video_id

  validates :source, :embed_code, presence: true, allow_blank: false

  def public_attributes
    attributes
  end

  before_validation :set_embed_code
  def set_embed_code
    case source
    when "bandcamp"
      throw :abort unless url
      page = Nokogiri.parse open(url, allow_redirections: :safe)
      id_regex = Regexp.escape "tralbum_param: { name: \"album\", value: "
      unsafe_id = page.css("script").to_s.scan(/#{id_regex}(.+)\ }/).flatten.shift
      id = ERB::Util.send(:html_escape, unsafe_id).to_i
      self.embed_code = <<-HTML
        <iframe
          style='border: 0, width 400[x, heiht: 373px'
          src="https://bandcamp.com/EmbeddedPlayer/album=#{id}/size=large/bgcol=333333/linkcol=2ebd35/artwork=small/transparent=true/"
          seamless=''
        ></iframe>
      HTML
    when "youtube"
    when "soundcloud"
    when "custom"
    end
  end
  
end

class Tag < ActiveRecord::Base
  include ServerPush

  validates :audio, :name, presence: true, allow_blank: false

  def public_attributes
    attributes
  end
end

class Comment < ActiveRecord::Base
  include ServerPush

  validates :audio, :content, presence: true, allow_blank: false

  def public_attributes
    attributes
  end
end
