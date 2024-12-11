require 'open-uri'
require 'json'
require 'faker'
require 'uri'
require 'net/http'

# URL email
URL_PATH = '@happy-tasks.click'
# Super users
BASE_USERS = [
  { first_name: "Guillaume", last_name: "Fournier", email: "gf#{URL_PATH}", child: false, password: "happyT"},
  { first_name: "Hélène", last_name: "Demanet", email: "hd#{URL_PATH}", child: false, password: "happyT"},
  { first_name: "Emilie", last_name: "Vennat-Louveau", email: "evl#{URL_PATH}", child: false, password: "happyT"},
  { first_name: "Cédric", last_name: "Lang-Roth", email: "clr#{URL_PATH}", child: false, password: "happyT"},
  { first_name: "Madame", last_name: "Fournier", email: "mf#{URL_PATH}", child: false, password: "happyT"},
  { first_name: "Monsieur", last_name: "Demanet", email: "md#{URL_PATH}", child: false, password: "happyT"},
  { first_name: "Monsieur", last_name: "Vennat-Louveau", email: "mvl#{URL_PATH}", child: false, password: "happyT"},
  { first_name: "Madame", last_name: "Lang-Roth", email: "mlr#{URL_PATH}", child: false, password: "happyT"},
]
# Types de tâches
TASK_TYPES = [
  "chambre", "linge", "ménage", "cuisine", "animaux", "apprentissage"
]
# liste des tâches
TASK_LIST = {
  chambre: ["Ranger la chambre", "Aérer la chambre", "Faire son lit", "Réorganiser sa chambre", "Préparer sa chambre"],
  linge: ["Ranger le linge", "Trier le linge", "Plier le linge", "Etendre le linge", "Apporter le linge"],
  ménage: ["Passer l'aspirateur", "Faire les vitres", "Passer le balai"],
  cuisine: ["Débarrasser le LV", "Mettre au LV", "Mettre la table", "Dabarrasser la table", "Cuisiner" ],
  animaux: ["Nourrir les animaux", "Sortir les animaux", "Entretenir les animaux"],
  apprentissage: ["Faire ses devoirs", "Prendre sa douche", "Se brosser les dents", "Aider aux devoirs", "Pratiquer une activité", "Jardiner"]
}
# types de récompenses/privilèges
AWARD_TYPES = [
  "quotidien", "hebdomadaire", "mensuel"
]
# liste des récompenses/privilèges
AWARD_LIST = {
  quotidien: ["Gagner 10 min d'écran", "Jeu de société rapide", "Gagner 10 min de télé"],
  hebdomadaire: ["Jeu de société en famille", "Inviter quelqu'un", "Sortir au cinéma avec quelqu'un"],
  mensuel: ["Sortir au restaurant", "Acheter des livres", "Sortir au cinéma en famille"]
}
# Age mini pour l'appli
MIN_AGE = 4
# Age maxi pour l'appli
MAX_AGE = 16
# Age pour avoir accès soi-même
AGE_ACCOUNT = 9
# Les points que
MIN_DAY_POINTS = 30
MAX_DAY_POINTS = 90
MIN_WEEK_POINTS = 40
MAX_WEEK_POINTS = 120
MIN_MONTH_POINTS = 60
MAX_MONTH_POINTS = 180
MIN_POINTS_TASK = 20
MAX_POINTS_TASK = 50
# points minimum pour un(e) récompense/privilège
MIN_AWARD_POINTS = {
  quotidien: MIN_POINTS_TASK / 3,
  hebdomadaire: MIN_POINTS_TASK / 2,
  mensuel: MIN_POINTS_TASK
}
# points maximum pour un(e) récompense/privilège
MAX_AWARD_POINTS = {
  quotidien: MAX_POINTS_TASK / 3,
  hebdomadaire: MAX_POINTS_TASK / 2,
  mensuel: MAX_POINTS_TASK
}



puts "---Destroying all data"
User.destroy_all
Child.destroy_all
Family.destroy_all
Award.destroy_all
Task.destroy_all
TaskType.destroy_all


puts "---All data destroyed"

puts "---Creating the 6 TaskTypes"
TASK_TYPES.each do |type|
  TaskType.create!(name: type)
end
puts "---6 Task_Types CREATED"


def create_the_rest(family)
  3.times do
    child = Child.create!(
       family_id: family.id,
       first_name: Faker::Name.first_name,
       age: (MIN_AGE..MAX_AGE).to_a.sample,
       day_points: (MIN_DAY_POINTS..MAX_DAY_POINTS).to_a.sample,
       week_points: (MIN_WEEK_POINTS..MAX_WEEK_POINTS).to_a.sample,
       month_points: (MIN_MONTH_POINTS..MAX_MONTH_POINTS).to_a.sample,)
    if child.age >= AGE_ACCOUNT
      User.create!(family_id: family.id, child_id: child.id, first_name: child.first_name, last_name: family.name, email: Faker::Internet.email, password: "happyT", child: true)
    else
      User.create!(family_id: family.id, child_id: child.id, first_name: child.first_name, last_name: family.name, email: Faker::Internet.email, password: "happyT", child: false)
    end
    award_type = AWARD_TYPES.sample
    award = Award.create!(child_id: child.id, name: AWARD_LIST[award_type.to_sym].sample, periodicity: award_type, value: (MIN_AWARD_POINTS[award_type.to_sym]..MAX_AWARD_POINTS[award_type.to_sym]).to_a.sample)
    4.times do
      task_type = TASK_TYPES.sample
      Task.create!(child_id: child.id, task_type_id: TaskType.find_by(name: task_type).id, name: TASK_LIST[task_type.to_sym].sample, value: (MIN_POINTS_TASK..MAX_POINTS_TASK).to_a.sample)
    end
  end
end


puts "---Creating base users"
BASE_USERS.take(4).each do |base_user|
  family = Family.create!(name: base_user[:last_name])
  User.create!(family_id: family.id, first_name: base_user[:first_name], last_name: base_user[:last_name], email: base_user[:email], child: base_user[:child], password: base_user[:password])
  create_the_rest(family)
end
puts "---Base users CREATED"

puts "---Creating 50 other families"

50.times do
  family = Family.create!(name: Faker::Name.last_name)
  first_name1 = Faker::Name.first_name
  first_name2 = Faker::Name.first_name
  user1 = User.create!(family_id: family.id, first_name: first_name1, last_name: family.name, email: Faker::Internet.email(name: first_name1), child: false, password: 'happyT')
  user2 = User.create!(family_id: family.id, first_name: first_name2, last_name: family.name, email: Faker::Internet.email(name: first_name2), child: false, password: 'happyT')
  create_the_rest(family)
end
puts "---50 Families CREATED"
