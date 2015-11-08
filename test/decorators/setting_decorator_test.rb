require 'test_helper'

#
# == SettingDecorator test
#
class SettingDecoratorTest < Draper::TestCase
  include Draper::LazyHelpers
  include AssetsHelper
  include UserHelper

  setup :initialize_test

  #
  # == Title / Subtitle
  #
  test 'should return correct title with span tag wrapping it' do
    assert_match "<span>Rails Starter</span>", @setting_decorated.title
  end

  test 'should return correct title with subtitle inline' do
    assert_equal "Rails Starter démarre rapidement", @setting_decorated.title_subtitle_inline
  end

  test 'should return correct title/subtitle formatted with html' do
    assert_match "<a href=\"/\" class=\"l-header-site-title-link \"><h1 class=\"l-header-site-title\"><span>Rails Starter</span><small class=\"l-header-site-subtitle\">Démarre rapidement</small></h1></a>", @setting_decorated.title_subtitle
  end

  #
  # == Logo
  #
  test 'should return nil if logo doesn\'t exisit' do
    assert_nil @setting_decorated.logo_deco
  end

  #
  # == Other
  #
  test 'should return correct credentials' do
    assert_equal "Rails Starter - Tous droits réservés - Copyright &copy; #{current_year}", @setting_decorated.credentials
  end

  test 'should have correct phone value adapted for w3c' do
    assert_equal '+33102030405', @setting_decorated.phone_w3c
  end

  test 'should have correct admin_link value if administrator' do
    sign_in @administrator
    assert_equal ' - <a target="blank" href="/admin"> administration</a>', @setting_decorated.admin_link
  end

  test 'should have correct admin_link value if not logged_in' do
    sign_in User.new
    assert_nil @setting_decorated.admin_link
  end

  test 'should have correct about value' do
    assert_equal '<a href="/a-propos">À propos</a>', @setting_decorated.about
    if @locales.include?(:en)
      I18n.with_locale(:en) do
        assert_equal '<a href="/en/about">About</a>', @setting_decorated.about
      end
    end
  end

  #
  # == Status tag for modules
  #
  test 'should return correct status_tag for breadcrumb' do
    assert_match "<span class=\"status_tag désactivé red\">Désactivé</span>", @setting_decorated.breadcrumb
  end

  test 'should return correct status_tag for qrcode' do
    assert_match "<span class=\"status_tag désactivé red\">Désactivé</span>", @setting_decorated.qrcode
  end

  test 'should return correct status_tag for social' do
    assert_match "<span class=\"status_tag désactivé red\">Désactivé</span>", @setting_decorated.social
  end

  test 'should return correct status_tag for maintenance' do
    assert_match "<span class=\"status_tag en_ligne green\">En Ligne</span>", @setting_decorated.maintenance
  end

  private

  def initialize_test
    @setting = settings(:one)

    @subscriber = users(:alice)
    @administrator = users(:bob)
    @super_administrator = users(:anthony)

    @locales = I18n.available_locales
    @setting_decorated = SettingDecorator.new(@setting)
  end
end