require "test_helper"

class TicketsControllerTest < ActionDispatch::IntegrationTest
  test "signed-out visitors are redirected to sign-in" do
    get root_path
    assert_redirected_to new_session_path

    get tickets_path
    assert_redirected_to new_session_path
  end

  test "after sign-in the visitor returns to the page they asked for" do
    get tickets_path
    post session_path, params: { email_address: "agent@example.com", password: fixture_password }

    assert_redirected_to tickets_url
  end

  test "customers see My tickets" do
    sign_in_as users(:customer)

    get root_path

    assert_response :success
    assert_select "h1", "My tickets"
  end

  test "agents see All tickets" do
    sign_in_as users(:agent)

    get root_path

    assert_response :success
    assert_select "h1", "All tickets"
  end

  test "top bar shows the user's email, role and a log out button" do
    sign_in_as users(:agent)

    get root_path

    assert_select "header.topbar" do
      assert_select ".user span", "agent@example.com · Agent"
      assert_select "form[action='#{session_path}'] button", "Log out"
    end
  end
end
