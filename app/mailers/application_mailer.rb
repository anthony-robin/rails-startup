#
# == Application Mailer
#
class ApplicationMailer < ActionMailer::Base
  before_action :set_setting

  def set_setting
    @settings = Setting.first
  end
end
