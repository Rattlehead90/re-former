require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(username: 'ExUsername', email: 'example@email.ex', password: 'abcd1234')
  end

  test 'should be valid' do
    assert @user.valid?
  end

  test 'should have a username' do
    @user.username = '    '
    assert_not @user.valid?
  end

  test 'username should be unique' do
    duplicate_user = @user.dup
    duplicate_user.username = @user.username
    @user.save
    assert_not duplicate_user.save
  end

  test 'email should be present' do
    @user.email = '    '
    assert_not @user.valid?
  end

  test 'email should be unique' do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email
    @user.save
    assert_not duplicate_user.save
  end

  test 'email should not be too long' do
    @user.email = 'a' * 244 + "@example.com"
    assert_not @user.valid?
  end

  test 'email validation should accept valid addresses' do
    valid_addresses = %w[user@example.com USER@foo.COM A_USER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |address|
      @user.email = address
      assert @user.valid?, "#{address.inspect} should be valid"
    end
  end

  test 'email validation should reject invalid addresses' do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |address|
      @user.email = address
      assert_not @user.valid?, "#{address} should not be valid"
    end
  end

  test 'email addresses should be saved as lowercase' do
    mixed_case_email = 'Foo@ExAMPle.CoM'
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end

  test 'should have a password' do
    @user.password = '    '
    assert_not @user.valid?
  end

  test 'password should have at least 6 characters' do
    @user.password = '12345'
    assert_not @user.valid?
  end

  test 'password should contain at least 1 digit' do
    @user.password = 'abcdefgh'
    assert_not @user.valid?
  end
end
