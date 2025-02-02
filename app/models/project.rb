# frozen_string_literal: true

# class Project
class Project < ApplicationRecord
  belongs_to :owner, class_name: "User", foreign_key: "user_id"
  has_many :collaborators, dependent: :destroy
  has_many :users, through: :collaborators
  has_many :tasks, dependent: :destroy
  validates :name, presence: true, uniqueness: { scope: :user_id }

  after_update_commit lambda {
                        users.each do |user|
                          broadcast_replace_later_to [user, "projects"],
                                                     partial: "projects/project",
                                                     locals: { project: self, user_id: user.id }
                        end
                      }

  after_destroy_commit lambda {
    users.each do |user|
      broadcast_remove_to [user, "projects"]
    end
  }

  alias_attribute :owner_id, :user_id

  scope :ordered, -> { order(id: :desc) }

  def role_for_user(user_id)
    return "owner" if owner_id == user_id

    collaborators.find { |colab| colab.user_id == user_id }&.role || "User not part of this project"
  end
end
