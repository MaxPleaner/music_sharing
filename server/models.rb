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
      if self.url.blank?
        errors.add "error, no url given"
        throw :abort
      end
      page = Nokogiri.parse open(self.url, allow_redirections: :safe)
      id_regex = Regexp.escape "tralbum_param: { name: \"album\", value: "
      unsafe_id = page.css("script").to_s.scan(/#{id_regex}(.+)\ }/).flatten.shift
      album_id = ERB::Util.send(:html_escape, unsafe_id).to_i
      self.embed_code = <<-HTML
        <iframe
          style='border: 0, width 400[x, heiht: 373px'
          src="https://bandcamp.com/EmbeddedPlayer/album=#{album_id}/size=large/bgcol=333333/linkcol=2ebd35/artwork=small/transparent=true/"
          seamless=''
        ></iframe>
      HTML
    when "youtube"
      if self.video_id.blank?
        errors.add "error, no video_id given"
        throw :abort
      end
      video_id = ERB::Util.send(:html_escape, self.video_id)
      self.embed_code = <<-HTML
        <iframe
          width="300"
          height="160"
          src="https://www.youtube.com/embed/#{video_id}"
          frameborder="0"
          allowfullscreen
        ></iframe>
      HTML
    when "soundcloud"
      if url.blank?
        errors.add "error, no url given"
        throw :abort
      end
      api_path = "https://soundcloud.com/oembed?format=json&url=#{url}&maxwidth=300&maxheight=160"
      self.embed_code = JSON.parse(open(api_path).read)["html"]
    when "custom"
    end
  rescue JSON::ParserError => e
    self.errors.add :base, "not a valid url"
    throw :abort
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
