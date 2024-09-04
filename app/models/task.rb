# frozen_string_literal: true

# Clask task
class Task < ApplicationRecord
  enum :status, %i[not_started in_progress done], default: :not_started, validate: true

  belongs_to :project
  belongs_to :user

  validates :name, presence: true, uniqueness: { scope: :project_id }
  validates :description, length: { maximum: 500 }
  validates :end_date, :status, presence: true

  after_initialize :set_defaults, if: :new_record?

  after_create_commit lambda {
    broadcast_prepend_later_to [user, "tasks"], locals: { project:, task: self }
  }

  after_update_commit lambda {
                        project.users.each do |user|
                          broadcast_replace_later_to [user, "tasks"], locals: { project:, task: self }
                        end
                      }

  after_destroy_commit lambda {
    project.users.each do |user|
      broadcast_remove_to [user, "tasks"]
    end
  }

  scope :ordered, -> { order(id: :desc) }

  private

  def set_defaults
    self.status = :not_started
  end
end
