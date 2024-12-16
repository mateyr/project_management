require "application_system_test_case"

class ProjectsTest < ApplicationSystemTestCase
  setup do
    login_as users(:admin)
  end

  test "There are no projects" do
    Project.destroy_all
    visit projects_path
    assert_selector ".group h3", text: "No projects"
  end

  test "Create a new project" do
    visit projects_path

    click_on "New project", match: :first
    fill_in "project_name", with: "Sistemas de Información"
    find('label.btn--primary').click
    assert_selector "#flash div", text: "Project was successfully created."
  end

  test "Update a project" do
    visit projects_path

    click_on "Edit project"
    fill_in "project_name", with: "Project management updated"
    find('label.btn--primary').click

    assert_selector "#flash div", text: "Project was successfully updated."
  end

  test "Delete a project" do
    visit projects_path
    click_on "Delete project", match: :first
    assert_selector "#flash div", text: "Project was successfully destroyed."
  end

  test "Uniqueness in project name" do
    visit projects_path

    click_on "New project", match: :first
    fill_in "project_name", with: "Project management"
    find("label.btn--primary").click
    assert_selector ".simple_form > div", text: "Name has already been taken"
  end

  test "Verifies that a project's update is displayed in real time for collaborators" do
    visit projects_path

    assert_selector "##{dom_id(projects(:one))} > div > a", text: "Project management"
    projects(:one).update!(name: "Project management updated")

    assert_selector "##{dom_id(projects(:one))} > div > a", text: "Project management updated"
  end

  test "Verifies that a project is removed in real time from collaborators' views when deleted" do
    visit projects_path

    assert_selector "##{dom_id(projects(:one))} > div > a", text: "Project management"
    projects(:one).destroy

    assert_selector ".group h3", text: "No projects"
  end

  # TODO: Investigate how to create a system test
  test "User cannot delete a project if not an admin" do
    login_as users(:collaborator)

    ability = Ability.new(users(:collaborator))
    assert ability.cannot?(:destroy, projects(:two))
  end

  test "User cannot manage a project if not an admin" do
    login_as users(:collaborator)

    ability = Ability.new(users(:collaborator))
    assert ability.cannot?(:manage, project_users(:two))
  end
end
