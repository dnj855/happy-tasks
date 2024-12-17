require "test_helper"

class CreateTasksJobTest < ActiveJob::TestCase
  def setup
    @child = children(:one)
    @sample_tasks = [
      {"10" => {"Chambre" => "Ranger ses jouets"}},
      {"10" => {"Cuisine" => "Mettre son assiette dans le lave-vaisselle"}},
      {"20" => {"Hygiène" => "Se brosser les dents"}},
      {"20" => {"Linge" => "Mettre son pyjama au sale"}},
      {"30" => {"Apprentissage" => "Faire ses devoirs"}}
    ]
    
    # Mock de la réponse OpenAI
    @mock_response = {
      "choices" => [
        {
          "message" => {
            "content" => {
              "prénom" => "Cédric",
              "tâches" => @sample_tasks
            }.to_json
          }
        }
      ]
    }
  end

  test "crée les task_types manquants" do
    # Mock la méthode client.chat
    OpenAI::Client.any_instance.stubs(:chat).returns(@mock_response)

    TaskType.delete_all
    
    # Créer un task_type existant
    TaskType.create!(name: 'Chambre')
    
    # Vérifier que seuls les nouveaux task_types sont créés
    assert_difference 'TaskType.count', 4 do
      CreateTasksJob.new.send(:ensure_task_types_exist, @sample_tasks)
    end

    # Vérifier que tous les task_types attendus existent
    expected_types = ['Chambre', 'Cuisine', 'Hygiène', 'Linge', 'Apprentissage']
    assert_equal expected_types.sort, TaskType.pluck(:name).sort
  end

  test "ne crée pas de doublons de task_types" do
    # Mock la méthode client.chat
    OpenAI::Client.any_instance.stubs(:chat).returns(@mock_response)
    
    # Créer tous les task_types d'abord
    ['Chambre', 'Cuisine', 'Hygiène', 'Linge', 'Apprentissage'].each do |name|
      TaskType.create!(name: name)
    end

    # Vérifier qu'aucun nouveau task_type n'est créé
    assert_no_difference 'TaskType.count' do
      CreateTasksJob.new.send(:ensure_task_types_exist, @sample_tasks)
    end
  end

  test "crée les tâches avec les bonnes valeurs" do
    # Préparation : s'assurer que les task_types existent
    TaskType.delete_all
    task_types = ['Chambre', 'Cuisine', 'Hygiène', 'Linge', 'Apprentissage'].map do |name|
      TaskType.create!(name: name)
    end

    assert_difference 'Task.count', 5 do
      CreateTasksJob.new.send(:create_tasks, @sample_tasks, @child)
    end

    # Vérifier les valeurs des tâches
    assert_equal 2, Task.where(value: 10).count
    assert_equal 2, Task.where(value: 20).count
    assert_equal 1, Task.where(value: 30).count
  end

  test "associe les tâches aux bons task_types" do
    # Préparation
    TaskType.delete_all
    chambre = TaskType.create!(name: 'Chambre')
    
    # Ne tester qu'avec une tâche pour simplifier
    tasks = [{"10" => {"Chambre" => "Ranger ses jouets"}}]
    
    CreateTasksJob.new.send(:create_tasks, tasks, @child)
    
    task = Task.last
    assert_equal chambre, task.task_type
    assert_equal "Ranger ses jouets", task.name
    assert_equal 10, task.value
    assert_equal @child, task.child
  end

  test "génère une erreur si le task_type n'existe pas" do
    # Préparation
    TaskType.delete_all
    tasks = [{"10" => {"CatégorieInexistante" => "Tâche test"}}]
    
    assert_raises(ActiveRecord::RecordNotFound) do
      CreateTasksJob.new.send(:create_tasks, tasks, @child)
    end
  end

  class CreateTasksJobTest < ActiveJob::TestCase
    def setup
      @child = children(:one)
      @sample_privileges = {
        "Quotidien" => [
          {"30" => "15 minutes de temps spécial avec les parents"},
          {"45" => "Choisir le dessert"},
          {"50" => "30 minutes de tablette"},
          {"60" => "Choisir le film du soir"},
          {"75" => "Rester debout 30 minutes plus tard"}
        ],
        "Hebdomadaire" => [
          {"150" => "Aller au parc"},
          {"180" => "Inviter un ami"},
          {"200" => "Choisir le menu d'un repas"},
          {"220" => "Aller au cinéma"},
          {"250" => "Aller à la piscine"}
        ],
        "Mensuel" => [
          {"500" => "Nouveau jouet à 20€"},
          {"800" => "Sortie spéciale avec papa ou maman"},
          {"1000" => "Aller au parc d'attractions"},
          {"1200" => "Nouveau jeu vidéo"},
          {"1500" => "Faire une activité au choix"}
        ]
      }
  
      @mock_response = {
        "choices" => [
          {
            "message" => {
              "content" => {
                "prénom" => "Cédric",
                "tâches" => @sample_tasks,
                "privilèges" => @sample_privileges
              }.to_json
            }
          }
        ]
      }
    end
  
    test "crée les privilèges avec les bonnes périodicités" do
      assert_difference 'Award.count', 15 do
        CreateTasksJob.new.send(:create_awards, @sample_privileges, @child)
      end
  
      assert_equal 5, Award.where(periodicity: 'Quotidien').count
      assert_equal 5, Award.where(periodicity: 'Hebdomadaire').count
      assert_equal 5, Award.where(periodicity: 'Mensuel').count
    end
  
    test "assigne les bons points selon la périodicité" do
      CreateTasksJob.new.send(:create_awards, @sample_privileges, @child)
      
      # Vérifier quelques valeurs spécifiques
      assert_not_nil Award.find_by(value: 30, periodicity: 'Quotidien')
      assert_not_nil Award.find_by(value: 180, periodicity: 'Hebdomadaire')
      assert_not_nil Award.find_by(value: 1000, periodicity: 'Mensuel')
    end
  
    test "inclut bien le temps spécial avec les parents dans les privilèges quotidiens" do
      CreateTasksJob.new.send(:create_awards, @sample_privileges, @child)
      
      temps_special = Award.find_by("name LIKE ?", "%temps spécial avec les parents%")
      assert_not_nil temps_special
      assert_equal 'Quotidien', temps_special.periodicity
    end
  
    test "initialise correctement les attributs par défaut" do
      CreateTasksJob.new.send(:create_awards, @sample_privileges, @child)
      
      award = Award.last
      assert_not award.given
      assert_nil award.date
    end
  end
end