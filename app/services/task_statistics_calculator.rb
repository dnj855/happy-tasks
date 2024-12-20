# app/services/task_statistics_calculator.rb
class TaskStatisticsCalculator
  def initialize(children)
    @children = children
  end

  def calculate_monthly_stats
    Rails.cache.fetch(cache_key, expires_in: 1.hour) do
      calculate_stats
    end
  end

  private

  def calculate_stats
    monthly_tasks = fetch_monthly_tasks
    task_types = fetch_task_types

    @children.each_with_object({}) do |child, counts|
      counts[child.id] = task_types.transform_values do |name|
        monthly_tasks.fetch([child.id, task_types.key(name)], 0)
      end
    end
  end

  def fetch_monthly_tasks
    Task.where(
      child_id: @children.pluck(:id),
      validated: true,
      created_at: Time.current.beginning_of_month..Time.current.end_of_month
    ).group(:child_id, :task_type_id).count
  end

  def fetch_task_types
    Rails.cache.fetch('task_types', expires_in: 24.hours) do
      TaskType.pluck(:id, :name).to_h
    end
  end

  def cache_key
    # Le cache_key inclut :
    # - Le mois actuel (pour reset chaque mois)
    # - Les IDs des enfants (pour reset si la liste change)
    # - La dernière mise à jour d'une tâche
    [
      'monthly_stats',
      Time.current.strftime('%Y-%m'),
      @children.pluck(:id).sort,
      Task.maximum(:updated_at)&.to_i
    ].join('/')
  end
end