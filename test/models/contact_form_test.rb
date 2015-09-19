require 'test_helper'

#
# == ContactForm model test
#
class ContactFormTest < ActiveSupport::TestCase
  test 'should responds to name, email, message, send_copy' do
    msg = ContactForm.new
    [:name, :email, :message, :send_copy, :nickname].each do |attr|
      assert msg.respond_to? attr
    end
  end

  test 'should accept valid attributes' do
    valid_attrs = {
      name: 'maria',
      email: 'maria@example.com',
      message: 'Lorem ipsum dolor sit amet',
      send_copy: true
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
      message: '',
      send_copy: ''
    }
    msg = ContactForm.new
    refute msg.valid?, 'should not be valid if all fields are empty'
  end

  test 'should not be valid if email attribute is wrong' do
    attrs = {
      name: 'maria',
      email: 'maria@example',
      message: 'Lorem ipsum dolor sit amet',
      send_copy: true
    }
    msg = ContactForm.new attrs
    refute msg.valid?, 'should not be valid if email is not properly formatted'
  end
end