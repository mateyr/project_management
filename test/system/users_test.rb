require "application_system_test_case"

class UsersTest < ApplicationSystemTestCase
  setup do
    # login_as users(:admin)
  end

  test "Sign in" do
    visit new_user_session_path

    fill_in "Email", with: "admin@example.com"
    fill_in "Password", with: "password"
    click_button "Sign in"

    assert_selector "#flash div", text: "Signed in successfully"
  end

  test "Sign in with a non-existent user" do
    visit new_user_session_path

    fill_in "Email", with: "developer@example.com"
    fill_in "Password", with: "password"
    click_button "Sign in"

    assert_selector "#flash div", text: "Invalid Email or password"
  end

  test "Sign up" do
    visit new_user_registration_path

    fill_in "Email", with: "developer@example.com"
    fill_in "Password", with: "password"
    click_button "Sign up"

    assert_selector "#flash div", text: "Welcome! You have signed up successfully"
  end

  test "Sign up with invalid email and blank password" do
    visit new_user_registration_path
    page.execute_script('document.querySelector("form").setAttribute("novalidate", true)')

    fill_in "Email", with: "invalid_email"
    click_button "Sign up"

    assert_selector ".email span", text: "is invalid"
    assert_selector ".password span", text: "can't be blank"
  end
end
