class ChildPolicy < ApplicationPolicy
  def create?
    true
  end

  def view?
    user.child? && user.child_id == record.id
  end

  # NOTE: Up to Pundit v2.3.1, the inheritance was declared as
  # `Scope < Scope` rather than `Scope < ApplicationPolicy::Scope`.
  # In most cases the behavior will be identical, but if updating existing
  # code, beware of possible changes to the ancestors:
  # https://gist.github.com/Burgestrand/4b4bc22f31c8a95c425fc0e30d7ef1f5

  class Scope < ApplicationPolicy::Scope
    def resolve
      if user.child?
        user.family.children.where(id: user.child_id)
      else
        user.family.children
      end
    end
  end
end
