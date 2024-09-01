# frozen_string_literal: true

class User < ApplicationRecord
  has_many :project_users
  has_many :projects, through: :project_users
  has_many :tasks
  devise :database_authenticatable, :registerable, :rememberable, :validatable
end
