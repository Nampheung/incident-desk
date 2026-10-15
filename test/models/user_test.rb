require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "downcases and strips email_address" do
    user = User.new(email_address: " DOWNCASED@EXAMPLE.COM ")
    assert_equal("downcased@example.com", user.email_address)
  end

  test "valid with an email, password and one role" do
    assert new_user.valid?
  end

  test "stores a hashed password, not the plain text" do
    user = new_user
    user.save!

    assert_not_equal fixture_password, user.password_digest
    assert user.authenticate(fixture_password)
  end

  test "email is required and must look like an email" do
    assert_not new_user(email_address: "").valid?
    assert_not new_user(email_address: "not-an-email").valid?
  end

  test "email is unique regardless of case" do
    user = new_user(email_address: "CUSTOMER@Example.com")

    assert_not user.valid?
    assert_includes user.errors[:email_address], "has already been taken"
  end

  test "role must be customer or agent" do
    assert_not new_user(role: "admin").valid?
    assert_not new_user(role: nil).valid?
  end

  test "the database refuses a second role for a user" do
    assert_raises(ActiveRecord::RecordNotUnique) { users(:customer).add_role(:agent) }

    assert users(:customer).reload.customer?
  end

  test "an invalid role on a saved user keeps the current role" do
    user = users(:customer)
    user.role = "admin"

    assert_not user.save
    assert user.reload.customer?
  end

  test "changing the role of a saved user takes effect on save" do
    user = users(:customer)
    user.role = "agent"

    assert User.find(user.id).customer?, "role must not change before save"

    user.save!
    assert user.reload.agent?
    assert_equal 1, user.roles.count
  end

  test "the database allows only one role row per name" do
    assert_raises(ActiveRecord::RecordNotUnique) { Role.insert!({ name: "customer" }) }
  end

  test "role helpers" do
    assert users(:customer).customer?
    assert_not users(:customer).agent?
    assert users(:agent).agent?
    assert_equal "agent", users(:agent).role
  end

  private
    def new_user(**attributes)
      User.new(email_address: "new@example.com", password: fixture_password, role: "customer", **attributes)
    end
end
