# == Schema Information
#
# Table name: event_orders
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  key        :string(255)
#

#
# == EventOrder Model
#
class EventOrder < ActiveRecord::Base
  has_one :event_setting
end