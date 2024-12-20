# frozen_string_literal: true

class User < ApplicationRecord
  has_many :collaborators
  has_many :involved_projects, through: :collaborators, source: :project
  has_many :tasks
  has_many :projects

  devise :database_authenticatable, :registerable, :rememberable, :validatable
end
