# frozen_string_literal: false
#
# == CommentDecorator
#
class CommentDecorator < ApplicationDecorator
  include Draper::LazyHelpers
  include AssetsHelper
  delegate_all

  #
  # == Extract pseudo and email from comment
  #
  def pseudo_registered_or_guest
    name = model.try(:user_id).nil? ? model.username : model.user_username
    name.capitalize
  end

  def email_registered_or_guest
    model.try(:user_id).nil? ? model.email : model.user_email
  end

  #
  # == Avatar associated to comment
  #
  def avatar
    # Not connected
    if model.try(:user_id).nil?
      gravatar_image_tag(model.email, alt: model.username, gravatar: { size: model.class.instance_variable_get(:@avatar_width), secure: true })

    # Connected
    else
      retina_thumb_square(model.user, @avatar_width)
    end
  end

  def author_with_avatar
    author_with_avatar_html(avatar, pseudo_registered_or_guest)
  end

  #
  # == Content
  #
  def preview_content
    truncate_html(model.content, length: 100, escape: true)
  end

  #
  # == Commentable
  #
  def commentable_path
    commentable.decorate.show_post_link
  end

  def link_source
    link_to "#{commentable_title} <br /> (#{t('comment.admin.go_to_source')})".html_safe, commentable_path, target: :_blank, class: 'button'
  end

  def link_and_image_source
    html = ''
    html << h.content_tag(:p) do
      "#{commentable.decorate.custom_cover} <br /> #{link_source}".html_safe
    end
    html.html_safe
  end

  def pseudo(name = nil)
    name = pseudo_registered_or_guest if name.nil?
    content_tag(:strong, name, class: 'comment-author')
  end
end
