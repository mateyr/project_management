require "application_system_test_case"

class ProjectsTest < ApplicationSystemTestCase
  setup do
    login_as users(:admin)
  end

  test "There are no projects" do
    Project.delete_all
    visit projects_path
    assert_selector ".group h3", text: "No projects"
  end

  test "Create a new project" do
    visit projects_path

    click_on "New project", match: :first
    fill_in "project_name", with: "Sistemas de Información"
    find('label.btn--primary').click
    assert_selector "#flash div", text: "Project was sucessfully created."
  end

  test "Update a project" do
    visit projects_path

    click_on "Edit project"
    fill_in "project_name", with: "Project management updated"
    find('label.btn--primary').click

    assert_selector "#flash div", text: "Project was sucessfully updated."
  end

  test "Delete a project" do
    visit projects_path

    click_on "Delete project", match: :first
    assert_selector "#flash div", text: "Project was sucessfully destroyed."
  end

  test "Uniqueness in project name" do
    visit projects_path

    click_on "New project", match: :first
    fill_in "project_name", with: "Project management"
    find("label.btn--primary").click
    assert_selector ".simple_form > div", text: "Name has already been taken"
  end
end
