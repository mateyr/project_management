# frozen_string_literal: true

# Project User
class ProjectUser < ApplicationRecord
  belongs_to :project
  belongs_to :user

  validates :user, uniqueness: { scope: :project, message: "already added to this project" }

  after_create_commit lambda {
                        broadcast_prepend_later_to [user, "projects"],
                                                   partial: "projects/project", locals: { project: },
                                                   target: "projects"
                      }

  after_destroy_commit -> { broadcast_remove_to [user, "projects"], target: project }
end
