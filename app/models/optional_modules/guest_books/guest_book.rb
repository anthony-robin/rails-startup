# == Schema Information
#
# Table name: guest_books
#
#  id         :integer          not null, primary key
#  username   :string(255)      not null
#  email      :string(255)      not null
#  content    :text(65535)      not null
#  lang       :string(255)      not null
#  validated  :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

#
# == GuestBook model
#
class GuestBook < ActiveRecord::Base
  include Scopable
  include Validatable

  validates :username, presence: true
  validates :email,
            presence: true,
            email_format: true

  validates :content, presence: true
  validates :lang,
            presence: true,
            inclusion: { in: I18n.available_locales.map(&:to_s) }

  default_scope { order('created_at DESC') }

  attr_accessor :nickname
  paginates_per 3

  alias_attribute :comment, :content
end