require 'open-uri'
require 'json'
require 'faker'
require 'uri'
require 'net/http'

# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

URL_PATH = '@happy-tasks.click'

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

TASK_TYPES = [
  "chambre", "linge", "ménage", "cuisine", "animaux", "apprentissage"
]

AWARD_TYPES = [
  "quotidien", "hebdomadaire", "mensuel"
]

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

puts "---Creating base users"
BASE_USERS.take(4).each do |base_user|
  family = Family.create!(name: base_user[:last_name])
  User.create!(family_id: family.id, first_name: base_user[:first_name], last_name: base_user[:last_name], email: base_user[:email], child: base_user[:child], password: base_user[:password])
  3.times do
    child = Child.create!(
       family: family,
       first_name: Faker::Name.first_name,
       age: (4..22).to_a.sample,
       day_points: (35..92).to_a.sample,
       week_points: (35..92).to_a.sample,
       month_points: (35..92).to_a.sample,)
    if child.age > 9
      User.create!(family_id: family.id, child_id: child.id, first_name: child.first_name, last_name: family.name, email: Faker::Internet.email, password: "happyT", child: true)
    else
      User.create!(family_id: family.id, child_id: child.id, first_name: child.first_name, last_name: family.name, email: Faker::Internet.email, password: "happyT", child: false)
    end
    award = Award.create!(child_id: child.id, name: "Jouer à la console", periodicity: AWARD_TYPES.sample, value: (50..250).to_a.sample)
    4.times do
      task_type = TaskType.all.sample
      case task_type.name
      when "chambre"
        name= ["Ranger la chambre", "Aérer la chambre", "Faire son lit", "Réorganiser sa chambre", "Préparer sa chambre"].sample
      when "linge"
        name= ["Ranger le linge", "Trier le linge", "Plier le linge", "Etendre le linge", "Apporter le linge"].sample
      when "ménage"
        name= ["Passer l'aspirateur", "Faire les vitres", "Passer le balai"].sample
      when "cuisine"
        name= ["Débarrasser le LV", "Mettre au LV", "Mettre la table", "Dabarrasser la table", "Cuisiner" ].sample
      when "animaux"
        name= ["Nourrir les animaux", "Sortir les animaux", "Entretenir les animaux", "Enterrer les animaux"].sample
      when "apprentissage"
        name= ["Faire ses devoirs", "Prendre sa douche", "Se brosser les dents", "Aider aux devoirs", "Pratiquer une activité", "Jardiner"].sample
      else
        "Erreur: ce type de tâche n'existe pas"
      end
      task = Task.create!(child_id: child.id, task_type: task_type, name: name, value: (30..100).to_a.sample)
    end
  end
end
puts "---Base users CREATED"
