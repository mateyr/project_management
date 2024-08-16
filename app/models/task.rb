# frozen_string_literal: true

# Clask task
class Task < ApplicationRecord
  enum :status, %i[not_started in_progress done], default: :not_started, validate: true

  belongs_to :project
  belongs_to :user

  validates :name, presence: true, uniqueness: true
  validates :description, length: { maximum: 500 }
  validates :end_date, :status, presence: true

  after_initialize :set_defaults, if: :new_record?

  scope :ordered, -> { order(id: :desc) }

  private

  def set_defaults
    self.status = :not_started
  end
end
