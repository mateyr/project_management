# frozen_string_literal: true

class User < ApplicationRecord
  has_many :project_users
  has_many :involved_projects, through: :project_users, source: :project
  has_many :tasks
  has_many :projects

  devise :database_authenticatable, :registerable, :rememberable, :validatable
end
