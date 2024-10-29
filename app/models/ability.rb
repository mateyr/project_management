# frozen_string_literal: true

# Ability
class Ability
  include CanCan::Ability

  def initialize(user)
    can :create, Project

    can :manage, Project, project_users: { user:, role: :admin }

    can :read, Project, project_users: { user: }

    can :manage, Task, project: { project_users: { user:, role: :admin } }

    can :read, Task, project: { project_users: { user: } }

    can(:update, Task, user:)

    can :manage, ProjectUser, project: { project_users: { user:, role: :admin } }
  end
end
