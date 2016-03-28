# frozen_string_literal: true
require 'test_helper'

class GuestBookTest < ActiveSupport::TestCase
  setup :initialize_test

  #
  # == Validation
  #
  test 'should be able to create if all good' do
    guest_book = GuestBook.new(content: 'youpi', username: 'leila', email: 'leila@skywalker.sw', lang: 'fr')
    assert guest_book.valid?
    assert guest_book.errors.keys.empty?
    assert_not guest_book.validated?
  end

  test 'should not be able to create if empty' do
    guest_book = GuestBook.new
    assert_not guest_book.valid?
    assert_equal [:username, :email, :content, :lang], guest_book.errors.keys
  end

  test 'should not be able to create if captcha filled' do
    guest_book = GuestBook.new(content: 'youpi', nickname: 'youpi', username: 'leila', email: 'leila@skywalker.sw', lang: 'fr')
    assert_not guest_book.valid?
    assert_equal [:nickname], guest_book.errors.keys
  end

  test 'should not be able to create if lang is not allowed' do
    guest_book = GuestBook.new(content: 'youpi', username: 'leila', email: 'leila@skywalker.sw', lang: 'zh')
    assert_not guest_book.valid?
    assert_equal [:lang], guest_book.errors.keys
  end

  test 'should not be able to create if email is not valid' do
    guest_book = GuestBook.new(content: 'youpi', username: 'leila', email: 'fakemail', lang: 'fr')
    assert_not guest_book.valid?
    assert_equal [:email], guest_book.errors.keys
  end

  test 'should have validated column to 1 if option disabled' do
    assert @guest_book_setting.should_validate?
    @guest_book_setting.update_attribute(:should_validate, false)
    assert_not @guest_book_setting.should_validate?

    guest_book = GuestBook.new(content: 'youpi', username: 'leila', email: 'leila@skywalker.sw', lang: 'fr')
    assert guest_book.valid?
    assert guest_book.errors.keys.empty?
    assert guest_book.validated?, 'guest_book should be automatically validated'
  end

  private

  def initialize_test
    @guest_book_setting = guest_book_settings(:one)
    @guest_book = guest_books(:fr_validate)
  end
end
