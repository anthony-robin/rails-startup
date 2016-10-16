# frozen_string_literal: true
require 'test_helper'

#
# == ContactForm model test
#
class ContactFormTest < ActiveSupport::TestCase
  setup :initialize_test

  test 'should responds to name, email, message, send_copy' do
    msg = ContactForm.new
    [:name, :email, :message, :send_copy, :nickname].each do |attr|
      assert msg.respond_to? attr
    end
  end

  #
  # == Validations
  #
  test 'should accept valid attributes' do
    valid_attrs = {
      name: 'maria',
      email: 'maria@example.com',
      message: 'Lorem ipsum dolor sit amet'
    }
    msg = ContactForm.new valid_attrs
    assert msg.valid?, 'should be all good !'
  end

  test 'should not be valid if blank attributes' do
    msg = ContactForm.new
    refute msg.valid?, 'should not be valid if all fields are blank'
  end

  test 'should not be valid if empty attributes' do
    attrs = {
      name: '',
      email: '',
      message: ''
    }
    msg = ContactForm.new attrs
    refute msg.valid?, 'should not be valid if all fields are empty'
  end

  test 'should not be valid if email attribute is wrong' do
    attrs = {
      name: 'maria',
      email: 'maria@example',
      message: 'Lorem ipsum dolor sit amet'
    }
    msg = ContactForm.new attrs
    refute msg.valid?, 'should not be valid if email is not properly formatted'
  end

  test 'should not be valid if captcha is filled' do
    attrs = {
      name: 'maria',
      email: 'maria@example.com',
      message: 'Lorem ipsum dolor sit amet',
      nickname: 'robots'
    }
    msg = ContactForm.new attrs
    assert_not msg.valid?
    assert_equal [:nickname], msg.errors.keys
  end

  #
  # == Attachment
  #
  test 'should not be valid if attachment type is not allowed' do
    file = File.new('./test/fixtures/images/bart.png')
    file.stubs(:size).returns(1.megabytes)
    file.stubs(:content_type).returns('images/psd')

    error_i18n_type = {
      attachment: [I18n.t('type', scope: @error_scope)]
    }

    attrs = {
      name: 'maria',
      email: 'maria@example.com',
      message: 'Lorem ipsum dolor sit amet',
      attachment: file,
      nickname: ''
    }
    msg = ContactForm.new attrs
    assert_not msg.valid?
    assert_equal [:attachment], msg.errors.keys
    assert_equal error_i18n_type, msg.errors.messages
  end

  test 'should not be valid if attachment size is too heavy' do
    file = File.new('./test/fixtures/images/bart.png')
    file.stubs(:size).returns(6.megabytes)
    file.stubs(:content_type).returns('text/plain')

    error_i18n_size = {
      attachment: [I18n.t('size', size: ContactForm::ATTACHMENT_MAX_SIZE, scope: @error_scope)]
    }

    attrs = {
      name: 'maria',
      email: 'maria@example.com',
      message: 'Lorem ipsum dolor sit amet',
      attachment: file,
      nickname: ''
    }
    msg = ContactForm.new attrs
    assert_not msg.valid?
    assert_equal [:attachment], msg.errors.keys
    assert_equal error_i18n_size, msg.errors.messages
  end

  def initialize_test
    @error_scope = ContactForm::I18N_SCOPE
  end
end
