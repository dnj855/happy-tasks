class CreateTasksJob < ApplicationJob
  queue_as :default

def perform(child_data)
  child = Child.find(child_data[:id])
  @child = child

  @prompt = format_prompt(
      first_name: child_data[:first_name],
      age: child_data[:age],
      autonomy_level: child_data[:autonomy_level],
      neuroatypical: child_data[:neuroatypical],
      neuroatypical_type: child_data[:neuroatypical_type]
    )

  Rails.logger.info "Démarrage du job pour l'enfant #{child.first_name} (ID: #{child.id})"
  
  chatgpt_response = client.chat(
    parameters: {
      model: "gpt-4o",
      messages: children_formatted_for_openai
    }
  )
  
  raw_content = chatgpt_response["choices"][0]["message"]["content"]
  Rails.logger.info "Réponse brute de l'API : #{raw_content}"

  json_match = raw_content.match(/\{.*\}/m)
  
  if json_match
    clean_json = json_match[0]
    puts "JSON nettoyé : #{clean_json}"
    parsed_data = JSON.parse(clean_json)
    Rails.logger.info "Données JSON parsées avec succès"
    
    ActiveRecord::Base.transaction do
      Rails.logger.info "Début de la transaction"
      
      task_types = ensure_task_types_exist(parsed_data["tâches"])
      Rails.logger.info "Task types créés/vérifiés : #{task_types.pluck(:name).join(', ')}"
      
      create_tasks(parsed_data["tâches"], child)
      Rails.logger.info "Tâches créées : #{Task.where(child: child).count}"
      
      create_awards(parsed_data["privilèges"], child)
      Rails.logger.info "Privilèges créés : #{Award.where(child: child).count}"
      
      Rails.logger.info "Transaction terminée avec succès"
    end
  else
    raise "Pas de JSON valide trouvé dans la réponse."
  end
rescue StandardError => e
  Rails.logger.error "Erreur dans le job : #{e.message}"
  Rails.logger.error e.backtrace.join("\n")
  raise e
end

  private
  
  def client
    @client ||= OpenAI::Client.new
  end

  def children_formatted_for_openai
    results = []
    results << { role: "system", content: @prompt}
  end

  private

  def ensure_task_types_exist(tasks)
    # Extraire les catégories uniques du JSON et les normaliser
    categories = tasks.flat_map do |task|
      task.values.first.keys.map(&:capitalize)
    end.uniq
  
    # Vérifier quelles catégories existent déjà (en ignorant la casse)
    existing_types = TaskType.where("LOWER(name) IN (?)", categories.map(&:downcase))
    existing_names = existing_types.pluck(:name).map(&:capitalize)
  
    # Créer les catégories manquantes
    missing_categories = categories - existing_names
    missing_categories.each do |category|
      TaskType.create!(name: category)
    end
  
    # Retourner tous les task_types pour pouvoir les utiliser après
    TaskType.where("LOWER(name) IN (?)", categories.map(&:downcase))
  end

  def create_tasks(tasks, child)
    tasks.each do |task_data|
      # task_data est de la forme {"10" => {"Chambre" => "Ranger ses jouets"}}
      task_data.each do |points, task_info|
        # task_info est de la forme {"Chambre" => "Ranger ses jouets"}
        task_info.each do |category, task_name|
          task_type = TaskType.find_by!(name: category)
          
          Task.create!(
            name: task_name,
            value: points.to_i,
            child: child,
            task_type: task_type,
            done: false,
            validated: false
          )
        end
      end
    end
  end

  def create_awards(privileges, child)
    privileges.each do |periodicity, awards_list|
      awards_list.each do |award_data|
        # award_data est de la forme {"30" => "15 minutes de temps spécial avec les parents"}
        award_data.each do |points, award_name|
          Award.create!(
            name: award_name,
            value: points.to_i,
            periodicity: periodicity,
            child: child,
            given: false
          )
        end
      end
    end
  end

  def format_prompt(first_name:, age:, autonomy_level:, neuroatypical:, neuroatypical_type:)
    base_prompt = 'Tu es spécialiste en psychologie comportementale, expert des travaux du psychologue américain Barkley et notamment de sa méthode de guidance parentale pour faciliter la vie quotidienne des familles.
  En fonction des paramètres suivants, crée 5 tâches (2 faciles, 2 moyennes et 1 difficile) et 15 privilèges (5 quotidiens, 5 hebdomadaires et 5 mensuels) pour l\'enfant #PRENOM#, âgé de #AGE# ans dont l\'autonomie est jugée à #AUTONOMY_LEVEL#/5 par ses parents.'
  
  end_prompt = '
  Note bien que les points des tâches accomplies seront divisées en 3, chaque tiers allant dans un compteur quotidien, hebdomadaire et mensuel.
  Note également que les tâches doivent pouvoir être réalisées tous les jours, il ne faut donc pas de tâche dont la réussite se juge sur toute une semaine. On ne peut pas non plus avoir de tâche qui soit le résultat de quelque chose dont l\'enfant ne peut pas maîtriser le fait que cela survienne (nettoyer après avoir sali, par exemple, ne peut pas fonctionner).
  Classe les privilèges, dans chaque périodicité, selon son intérêt pour l\'enfant. Et attribue des points en fonction de cet intérêt.
  Les points des privilèges doivent donc tenir compte de cela (les points quotidiens doivent être compris entre 10 et 30 points, les points hebdomadaires entre 100 et 500 points et les points mensuels doivent être compris entre 300 et 2000). Un (et un seul) privilège quotidien sera systématiquement un temps spécial avec les parents.
  Tiens bien compte de l\'âge de l\'enfant pour définir ses tâches et ses privilèges. Toutes les tâches doivent avoir une tournure positive et être simples et précises. Tu dois également les catégoriser parmi cette liste :  "Chambre", "Linge", "Ménage", "Cuisine", "Animaux", "Apprentissage", "Hygiène" et préciser la catégorie au bon endroit dans ta réponse.
  Ta réponse devra consister en un objet JSON, sans aucun texte introductif ou conclusif, sur le format suivant.
{
  "prénom": "#PRENOM#",
  "tâches": [
    {"10": {"CATEGORIE": "TACHEA10POINTS"}},
    {"10": {"CATEGORIE": "TACHEA10POINTS"}},
    {"20": {"CATEGORIE": "TACHEA20POINTS"}},
    {"20": {"CATEGORIE": "TACHEA20POINTS"}},
    {"30": {"CATEGORIE": "TACHEA30POINTS"}}
  ],
  "privilèges": {
    "Quotidien": [
      {"NOMBREDEPOINTS": "PRIVILEGE"}
    ],
    "Hebdomadaire": [
      {"NOMBREDEPOINTS": "PRIVILEGE"}
    ],
    "Mensuel": [
      {"NOMBREDEPOINTS": "PRIVILEGE"}
    ]
  }
}'
    
    prompt = base_prompt.gsub('#PRENOM#', first_name.to_s).gsub('#AGE#', age.to_s).gsub('#AUTONOMY_LEVEL#', autonomy_level.to_s)
    
    if neuroatypical
      prompt += ". L'enfant est neuroatypique"
      prompt += " (#{neuroatypical_type})" if neuroatypical_type.present?
      prompt += ". Adapte les tâches et privilèges en conséquence"
    end
    
    prompt + end_prompt
  end

  {
        id: 451,
        first_name: Child.find(451).first_name,
        age: Child.find(451).age,
        neuroatypical: "0",
        neuroatypical_type: nil,
        autonomy_level: 4
      }

end
