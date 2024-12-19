# app/services/task_statistics_calculator.rb
class TaskStatisticsCalculator
  def initialize(children)
    @children = children
  end

  def calculate_monthly_stats
    @children.each_with_object({}) do |child, counts|
      counts[child.id] = calculate_child_stats(child)
    end
  end

  private

  def calculate_child_stats(child)
    TaskType.all.each_with_object({}) do |task_type, task_hash|
      task_hash[task_type.name] = count_monthly_tasks(child, task_type)
    end
  end

  def count_monthly_tasks(child, task_type)
    child.tasks
      .where(task_type_id: task_type.id, validated: true)
      .where(created_at: Time.current.beginning_of_month..Time.current.end_of_month)
      .count
  end
end