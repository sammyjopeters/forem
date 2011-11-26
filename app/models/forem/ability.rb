require 'cancan'

module Forem
  class Ability < ::Ability
    include CanCan::Ability

    def self.included(target)
      target.class_eval do

        def initialize(user)
          # Let other permissions run before this
          super

          user ||= User.new # anonymous user

          if user.can_read_forem_forums?
            can :read, Forem::Forum do |forum|
              user.can_read_forem_forum?(forum)
            end
          end

          can :read, Forem::Category do |category|
            user.can_read_forem_category?(category)
          end
        end
      end
    end
  end
end
