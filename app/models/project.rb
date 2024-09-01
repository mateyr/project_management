# frozen_string_literal: true

# class Project
class Project < ApplicationRecord
  has_many :project_users, dependent: :destroy
  has_many :users, through: :project_users
  has_many :tasks, dependent: :destroy
  validates :name, presence: true, uniqueness: true

  after_update_commit lambda {
                        users.each do |user|
                          broadcast_replace_later_to [user, "projects"]
                        end
                      }

  after_destroy_commit lambda {
    users.each do |user|
      broadcast_remove_to [user, "projects"]
    end
  }

  scope :ordered, -> { order(id: :desc) }
end
