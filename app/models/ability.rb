# frozen_string_literal: true

# Ability
class Ability
  include CanCan::Ability

  def initialize(user)
    can :create, Project

    can(:manage, Project, owner: user)

    can :manage, Project, collaborators: { user:, role: :admin }

    can :read, Project, collaborators: { user: }

    can :manage, Task, project: { collaborators: { user:, role: :admin } }

    can :read, Task, project: { collaborators: { user: } }

    can(:update, Task, user:)

    can :manage, Collaborator, project: { owner: user }

    can :manage, Collaborator, project: { collaborators: { user:, role: :admin } }
  end
end
