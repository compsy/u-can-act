# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(person)
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
    case person&.role&.group
    when Person::STUDENT
      can :update, Person, %i[first_name last_name gender iban mobile_phone]
    when Person::MENTOR
      can :update, Person, %i[first_name last_name gender email mobile_phone]
    when Person::SOLO
      can :update, Person, %i[email ip_hash]
    end
  end
end
