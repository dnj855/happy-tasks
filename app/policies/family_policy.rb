class FamilyPolicy < ApplicationPolicy
  def view?
    user.child? && user.family == record
  end

  def create?
    true
  end

  def new_children?
    true
  end

  def create_children?
    true
  end
  # NOTE: Up to Pundit v2.3.1, the inheritance was declared as
  # `Scope < Scope` rather than `Scope < ApplicationPolicy::Scope`.
  # In most cases the behavior will be identical, but if updating existing
  # code, beware of possible changes to the ancestors:
  # https://gist.github.com/Burgestrand/4b4bc22f31c8a95c425fc0e30d7ef1f5

  class Scope < ApplicationPolicy::Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      if user.child?
        scope.where(id: user.family_id)
      else
        scope.all
      end
    end
  end
end
