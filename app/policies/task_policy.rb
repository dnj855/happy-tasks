class TaskPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.child?
        scope.where(child: user.family.children)
      else
        scope.where(child: user.family.children)
      end
    end
  end

  def index?
    true
  end

  def destroy?
    not_a_child?
  end

  def update?
    not_a_child?
  end

  def create?
    true
  end

  def destroy?
    update?
  end

  def validate?
    not_a_child?
  end

  def declare_done?
    user.admin? || record.user_id == user.id
  end

  # NOTE: Up to Pundit v2.3.1, the inheritance was declared as
  # `Scope < Scope` rather than `Scope < ApplicationPolicy::Scope`.
  # In most cases the behavior will be identical, but if updating existing
  # code, beware of possible changes to the ancestors:
  # https://gist.github.com/Burgestrand/4b4bc22f31c8a95c425fc0e30d7ef1f5

  class Scope < ApplicationPolicy::Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end

  private
  def not_a_child?
    !user.child? && user.family == record.child.family
  end

end
