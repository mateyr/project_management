# frozen_string_literal: true

# Project User
class Collaborator < ApplicationRecord
  enum :role, %i[admin collaborator], default: :collaborator, validate: true

  belongs_to :project
  belongs_to :user

  validates :user, uniqueness: { scope: :project, message: "already added to this project" }

  after_initialize :set_default_rol, if: :new_record?

  after_create_commit lambda {
                        broadcast_prepend_later_to [user, "projects"],
                                                   partial: "projects/project", locals: { project: },
                                                   target: "projects"
                      }

  after_destroy_commit -> { broadcast_remove_to [user, "projects"], target: project }

  private

  def set_default_rol
    self.role ||= :admin
  end
end
