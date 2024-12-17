namespace :test do
  desc "Test du CreateTasksJob avec un faux enfant"
  task test_tasks_job: :environment do
    puts "\n=== DÉBUT DU TEST ===\n\n"
    
    puts "Création d'une famille de test..."
    family = Family.create!(name: "Famille Test")
    
    puts "Création d'un enfant de test..."
    child = Child.create!(
      first_name: "Cédric",
      age: 4,
      day_points: 0,
      week_points: 0,
      month_points: 0,
      family: family
    )
    
    child_data = {
      id: child.id,
      first_name: "Cédric",
      age: 4,
      neuroatypical: true,
      neuroatypical_type: "TDAH",
      autonomy_level: 2
    }
    
    # Ne passons que les paramètres attendus par format_prompt
    prompt_params = {
      first_name: child_data[:first_name],
      age: child_data[:age],
      autonomy_level: child_data[:autonomy_level],
      neuroatypical: child_data[:neuroatypical],
      neuroatypical_type: child_data[:neuroatypical_type]
    }
    
    # Ajoutons un log pour voir le prompt généré
    job = CreateTasksJob.new
    prompt = job.send(:format_prompt, **prompt_params)
    puts "\n=== PROMPT GÉNÉRÉ ===\n\n"
    puts prompt
    
    puts "\n=== EXÉCUTION DU JOB ===\n\n"
    CreateTasksJob.perform_now(child_data)
  end
end