
# I only want to use open URI to open urls not local files.
# Don't fuck with me ...
module Kernel
  def http_get(url, *args)
    return nil unless url.start_with? "http://"
    open(url, *args)
  end
end

class EmbedUrl

  # This method returns a proc which is expected to be called using instance_eval
  # on a Model instance.
  #
  # The model should have this signature:
  # - :source, :url, and :video_id require attr_readers defined
  # - :embed_code requires an attr_writer
  #
  def self.build(source, url, video_id)
    Proc.new do
      case source
      when "bandcamp"
        instance_eval &(EmbedUrl.bandcamp(source, url))
      when "youtube"
        instance_eval &(EmbedUrl.youtube(source, video_id))
      when "soundcloud"
        instance_eval &(EmbedUrl.soundcloud(source, url))
      when "custom"
      end
    end      
  end

  def self.bandcamp source, url
    Proc.new do
      if url.blank?
        errors.add "error, no url given"
        throw :abort
      elsif url.start_with? "https://"
        errors.add :base, "please use the http:// version of bandcamp urls, not https://"
        throw :abort
      end
      page = Nokogiri.parse http_get(url, allow_redirections: :safe)
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
    end
  end

  def self.youtube source, video_id
    Proc.new do
      if video_id.blank?
        errors.add :base, "error, no video_id given"
        throw :abort
      else
        page = Nokogiri.parse http_get(
          "http://www.youtube.com/watch?v=#{video_id}",
          allow_redirections: :safe
        )
        if page.css(".watch-title").empty?
          errors.add :base, "invalid video id for youtube"
          throw :abort
        end
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
    end
  end

  def self.soundcloud source, url
    Proc.new do
      if url.blank?
        errors.add :base, "error, no url given"
        throw :abort
      end
      api_path = "http://soundcloud.com/oembed?format=json&url=#{url}&maxwidth=300&maxheight=160"
      embed_api_response = http_get(api_path)
      if embed_api_response
        self.embed_code = JSON.parse(embed_api_response.read)["html"]
      else
        errors.add :base, "invalid soundcloud url"
        throw :abort
      end
    end
  end

  def self.custom
  end


end
