require "application_system_test_case"

class TasksTest < ApplicationSystemTestCase
  setup do
    login_as users(:admin)
  end

  test "There are no tasks" do
    projects(:one).tasks.destroy_all
    visit project_path(projects(:one))

    assert_selector ".group h3", text: "No tasks"
  end

  test "Create a new task" do
    visit project_path(projects(:one))

    click_on "New task", match: :first
    fill_in "task_name", with: "Second task"
    select "admin@example.com", from: "task_user_id"
    fill_in "task_end_date", with: Date.today
    find('label.btn--primary').click

    assert_selector "#flash div", text: "Task was sucessfully created."
  end

  test "Update a task" do
    visit project_path(projects(:one))

    click_on "Edit task"
    fill_in "task_name", with: "Task updated"
    fill_in "task_end_date", with: Date.tomorrow
    find('label.btn--primary').click

    assert_selector "#flash div", text: "Task was sucessfully updated."
  end

  test "Delete a task" do
    visit project_path(projects(:one))
    click_on "Delete task"
    assert_selector "#flash div", text: "Task was sucessfully destroyed."
  end

  test "validates presence of required fields" do
    visit project_path(projects(:one))

    click_on "New task"
    assert_selector 'form#new_task', visible: true
    page.execute_script('document.querySelector("form#new_task").setAttribute("novalidate", true)')
    find('label.btn--primary').click

    assert_selector "#new_task>form>div", text: "User must exist, name can't be blank, and end date can't be blank"
  end

  test "Broadcast update" do
    visit project_path(projects(:one))

    assert_selector "##{dom_id(tasks(:one))} > div > div > a", text: "Create database"

    Task.find(tasks(:one).id).update!(name: "Create database update")

    assert_selector "##{dom_id(tasks(:one))} > div > div > a", text: "Create database update"
  end

  test "Broadcast delete" do
    visit project_path(projects(:one))

    assert_selector "##{dom_id(tasks(:one))} > div > div > a", text: "Create database"

    Task.find(tasks(:one).id).destroy

    assert_selector ".group h3", text: "No tasks"
  end

  test "Show action buttons only to owner or admin" do
    visit project_path(projects(:one))

    assert_text "New task"
    assert_text "Manage collaborators"

    # Log in with a non-owner or non-admin account
    click_on "Sign out"
    Collaborator.create!(project: projects(:one), user: users(:collaborator), role: :collaborator)
    login_as users(:collaborator)
    visit project_path(projects(:one))

    assert_no_text "New task"
    assert_no_text "Manage collaborators"
  end
end
