require "application_system_test_case"

class CollaboratorsTest < ApplicationSystemTestCase
  setup do
    login_as users(:admin)
  end

  test "Add a collaborator to a project" do
    visit project_path(projects(:one))

    click_on "Manage collaborators"
    click_on "New collaborator"
    select "collaborator@example.com", from: "collaborator_user_id"
    select "Admin", from: "collaborator_role"
    find('label.btn--primary').click

    assert_selector "#flash div", text: "Collaborador was successfully added."
  end

  test "Remove a collaborator from a project" do
    visit project_path(projects(:one))

    click_on "Manage collaborators"
    click_on "Delete collaborator"
    assert_selector "#flash div", text: "Collaborador was successfully destroyed."
  end

  test "Update a collaborator" do
    visit project_collaborators_path(projects(:one))

    click_on "Edit collaborator"
    select "Collaborator", from: "collaborator_role"
    find('label.btn--primary').click

    assert_selector "#flash div", text: "Collaborador was successfully updated."
  end

  test "Verifies that a project added to a user is correctly displayed in the user's interface in real time" do
    users(:admin).projects.destroy_all
    visit projects_path

    assert_selector ".group h3", text: "No projects"

    Collaborator.create!(project_id: projects(:two).id, user_id: users(:admin).id)

    assert_selector "##{dom_id(projects(:two))} > div > a", text: "Broadcast to admin user"
  end

  test "Verifies that a project is removed from the user's interface in real time" \
       "when the user is removed from the project" do
    visit projects_path

    assert_selector "##{dom_id(projects(:one))} > div > a", text: "Project management"

    Collaborator.find_by(project_id: projects(:one), user_id: users(:admin)).destroy

    assert_selector ".group h3", text: "No projects"
  end
end
