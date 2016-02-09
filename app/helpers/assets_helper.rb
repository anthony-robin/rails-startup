#
# == AssetsHelper
#
module AssetsHelper
  def attachment_url(file, style = :original, req = request)
    if file.nil?
      URI.join(req.url, "/default/#{style}-missing.png").to_s
    else
      URI.join(req.url, file.url(style)).to_s
    end
  end

  #
  # == Pictures
  #
  def retina_thumb_square(resource, size = 64)
    if resource.avatar?
      retina_image_tag(resource, :avatar, :thumb, default: [size, size])
    else
      gravatar_image_tag(resource.email, alt: resource.username, gravatar: { size: size })
    end
  end

  #
  # == Videos
  #
  def show_video_background?(video_settings, video_module)
    video_settings.video_upload? && video_settings.video_background? && video_module.enabled?
  end
end
