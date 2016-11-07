# frozen_string_literal: true

# == Schema Information
#
# Table name: newsletter_settings
#
#  id                 :integer          not null, primary key
#  send_welcome_email :boolean          default(TRUE)
#  title_subscriber   :string(255)
#  content_subscriber :text(65535)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

#
# NewsletterSetting Model
# ===========================
class NewsletterSetting < ApplicationRecord
  include MaxRowable

  # Translations
  translates :title_subscriber, :content_subscriber, fallbacks_for_empty_translations: true
  active_admin_translates :title_subscriber, :content_subscriber

  # Model relations
  has_many :newsletter_user_roles, as: :rollable, dependent: :destroy
  accepts_nested_attributes_for :newsletter_user_roles, reject_if: :all_blank, allow_destroy: true

  # Validation rules
  validates_associated :newsletter_user_roles
end
