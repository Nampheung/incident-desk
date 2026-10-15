require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "sign-in page shows the email and password fields" do
    get new_session_path

    assert_response :success
    assert_select "form.auth-card" do
      assert_select "input[type=email][name=email_address]"
      assert_select "input[type=password][name=password]"
      assert_select "input[type=submit][value='Sign in']"
    end
    assert_select ".alert-error", count: 0
  end

  test "valid credentials sign in and redirect to the dashboard" do
    post session_path, params: { email_address: "customer@example.com", password: fixture_password }

    assert_redirected_to root_url
    assert cookies[:session_id].present?
  end

  test "email is matched case-insensitively" do
    post session_path, params: { email_address: "  Customer@Example.COM ", password: fixture_password }

    assert_redirected_to root_url
  end

  test "invalid password re-shows the form with a generic message and keeps the email" do
    post session_path, params: { email_address: "customer@example.com", password: "wrong" }

    assert_response :unprocessable_entity
    assert_select ".alert-error", text: "Invalid email or password"
    assert_select "input[name=email_address][value='customer@example.com']"
    assert_select "input[name=password]:not([value])"
    assert cookies[:session_id].blank?
  end

  test "unknown email shows the same generic message" do
    post session_path, params: { email_address: "nobody@example.com", password: fixture_password }

    assert_response :unprocessable_entity
    assert_select ".alert-error", text: "Invalid email or password"
  end

  test "repeated sign-in attempts are rate-limited" do
    store = SessionsController.cache_store
    store.define_singleton_method(:increment) { |*| 11 }

    post session_path, params: { email_address: "customer@example.com", password: fixture_password }

    assert_response :too_many_requests
    assert_select ".alert-error", text: /Too many sign-in attempts/
    assert cookies[:session_id].blank?
  ensure
    store.singleton_class.remove_method(:increment)
  end

  test "signed-in users visiting sign-in go to the dashboard" do
    sign_in_as users(:customer)

    get new_session_path

    assert_redirected_to root_path
  end

  test "log out ends the session and returns to sign-in" do
    sign_in_as users(:customer)

    delete session_path

    assert_redirected_to new_session_path
    assert cookies[:session_id].blank?

    get root_path
    assert_redirected_to new_session_path
  end

  test "signed-out visitors cannot log out" do
    delete session_path

    assert_redirected_to new_session_path
  end

  test "there is no password-reset flow" do
    get "/passwords/new"

    assert_response :not_found
  end
end
