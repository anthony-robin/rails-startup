# == Schema Information
#
# Table name: categories
#
#  id                 :integer          not null, primary key
#  title              :string(255)
#  name               :string(255)
#  color              :string(255)
#  show_in_menu       :boolean          default(TRUE)
#  show_in_footer     :boolean          default(FALSE)
#  position           :integer
#  optional           :boolean          default(FALSE)
#  optional_module_id :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
# Indexes
#
#  index_categories_on_optional_module_id  (optional_module_id)
#

#
# == Category Model
#
class Category < ActiveRecord::Base
  include Imageable
  include Positionable

  translates :title
  active_admin_translates :title

  attr_accessor :custom_background_color

  belongs_to :optional_module
  has_one :slider, dependent: :destroy

  has_one :heading, as: :headingable, dependent: :destroy
  accepts_nested_attributes_for :heading, reject_if: :all_blank, allow_destroy: true

  has_one :background, as: :attachable, dependent: :destroy
  accepts_nested_attributes_for :background, reject_if: :all_blank, allow_destroy: true

  has_one :referencement, as: :attachable, dependent: :destroy
  accepts_nested_attributes_for :referencement, reject_if: :all_blank, allow_destroy: true

  delegate :description, :keywords, to: :referencement, prefix: true, allow_nil: true
  delegate :enabled, to: :optional_module, prefix: true, allow_nil: true

  scope :visible_header, -> { where(show_in_menu: true) }
  scope :visible_footer, -> { where(show_in_footer: true) }
  scope :with_allowed_module, -> { eager_load(:optional_module).where('(optional=? AND optional_module_id IS NULL) OR (optional=? AND optional_modules.enabled=?)', false, true, true) }

  def self.models_name
    [:Home, :About, :Contact, :Search, :GuestBook, :Blog, :Event]
  end

  def self.models_name_str
    %w( Home About Contact Search GuestBook Blog Event )
  end

  def self.title_by_category(category)
    Category.find_by(name: category).title
  end

  def self.handle_pages_for_background(new_record)
    categories = Category.includes(:background).except_already_background if new_record
    categories = with_allowed_module unless new_record

    categories.collect { |c| [c.title, c.id] }
  end

  def slider?
    !slider.nil?
  end

  private

  def self.except_already_background
    categories = []
    Category.with_allowed_module.each do |category|
      categories << category if category.background.nil?
    end
    categories
  end
end
