# frozen_string_literal: true

#
# == Blog Setting
#
puts 'Creating Blog Setting'
BlogSetting.create!(
  prev_next: true,
  show_last_comments: true
)
