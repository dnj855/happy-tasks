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
  "Chambre", "Linge", "Ménage", "Cuisine", "Animaux", "Apprentissage", "Hygiène"
]
# liste des tâches
TASK_LIST = {
  Chambre: ["Ranger sa chambre", "Aérer la chambre", "Faire son lit", "Réorganiser sa chambre", "Préparer sa chambre"],
  Linge: ["Ranger le linge", "Trier le linge", "Plier le linge", "Etendre le linge", "Apporter le linge"],
  Ménage: ["Passer l'aspirateur", "Faire les vitres", "Passer le balai", "Enlever les toiles d'araignée", "Aspirer dans la voiture"],
  Cuisine: ["Débarrasser le lave-vaisselle", "Mettre au lave-vaisselle", "Mettre la table", "Débarrasser la table", "Cuisiner" ],
  Animaux: ["Nourrir les animaux", "Sortir les animaux", "Entretenir les animaux", "Préparer le transport", "Entretenir l'habitat"],
  Apprentissage: ["Faire ses devoirs", "Aider aux devoirs", "Pratiquer une activité", "Jardiner", "Arroser les plantes"],
  Hygiène: ["Prendre sa douche", "Se brosser les dents", "Se couper les ongles", "Faire sa toilette", "Préparer ses vêtements du lendemain"]
  # Informatique : ["Débugguer l'application de maman ou papa"]
}

TASK_DESCRIPTIONS = {
  "Aspirer dans la voiture" => "Passer l'aspirateur pour enlever la poussière et les saletés.",
  "Entretenir l'habitat" => "Nettoyer l'espace de l'animal, changer l'eau, vérifier son confort, etc.",
  "Faire sa toilette" => "Se laver le visage, les mains, et se coiffer pour être propre et frais.",
  "Préparer ses vêtements du lendemain" => "Choisir des vêtements propres adaptés au lendemain pour gagner du temps.",
  "Préparer le transport" => "Faire en sorte que le moyen de transport (cage, laisse, etc.) et la nourriture soient prêts.",
  "Enlever les toiles d'araignée" => "Faire le tour de la maison et enlever les toiles d'araignée les plus gênantes.",
  "Faire ses devoirs" => "Terminer les exercices et réviser la leçon du jour.",
  "Mettre la table" => "Disposer les couverts, assiettes et verres correctement.",
  "Aider à la cuisine" => "Couper les légumes et préparer les ingrédients.",
  "Ranger sa chambre" => "Ramasser les objets qui traînent, les remettre à leur place, et s'assurer que la pièce est bien organisée.",
  "Aérer la chambre" => "Ouvrir les fenêtres pendant au moins 10 minutes pour renouveler l'air et rendre la pièce plus agréable.",
  "Faire son lit" => "Redresser les draps, replacer la couverture et les oreillers pour un lit bien fait.",
  "Réorganiser sa chambre" => "Changer la disposition des meubles ou organiser les objets pour optimiser l'espace.",
  "Préparer sa chambre" => "S'assurer que tout est en ordre et prêt pour accueillir un invité ou une activité.",
  "Ranger le linge" => "Placer les vêtements propres dans les armoires ou les tiroirs, bien pliés ou sur cintres.",
  "Trier le linge" => "Séparer les vêtements par couleur ou type pour préparer une lessive.",
  "Plier le linge" => "Prendre les vêtements secs et les plier proprement pour les ranger.",
  "Étendre le linge" => "Sortir le linge de la machine à laver et le suspendre correctement sur un étendoir.",
  "Apporter le linge" => "Transporter le linge propre ou sale à l'endroit approprié.",
  "Passer l'aspirateur" => "Nettoyer le sol en aspirant poussières et saletés.",
  "Faire les vitres" => "Nettoyer les fenêtres avec un produit adapté et un chiffon propre pour enlever les traces.",
  "Passer le balai" => "Balayer les sols pour enlever les poussières et les petits déchets.",
  "Débarrasser le lave-vaisselle" => "Retirer la vaisselle propre du lave-vaisselle et la ranger à sa place.",
  "Mettre au lave-vaisselle" => "Placer la vaisselle sale dans le lave-vaisselle après l'avoir rincée.",
  "Mettre la table" => "Disposer les couverts, assiettes et verres nécessaires pour le repas.",
  "Débarrasser la table" => "Retirer les assiettes, couverts et autres objets après le repas.",
  "Cuisiner" => "Préparer un plat ou une recette en suivant les instructions données.",
  "Nourrir les animaux" => "Remplir les gamelles des animaux avec leur nourriture et de l'eau.",
  "Sortir les animaux" => "Emmener les animaux en promenade pour leur exercice quotidien.",
  "Entretenir les animaux" => "S'occuper du toilettage, du nettoyage de la cage ou des soins spécifiques.",
  "Faire ses devoirs" => "Réaliser les exercices scolaires et réviser les leçons pour l'école.",
  "Prendre sa douche" => "Se laver soigneusement avec du savon, du shampooing et de l'eau.",
  "Se brosser les dents" => "Nettoyer les dents avec une brosse et du dentifrice pendant deux minutes.",
  "Aider aux devoirs" => "Accompagner une autre personne pour l'aider dans ses exercices scolaires.",
  "Pratiquer une activité" => "Consacrer du temps à un loisir ou une activité physique comme le sport, la musique, ou la peinture.",
  "Jardiner" => "Planter, arroser ou entretenir des plantes dans le jardin.",
  "Arroser les plantes" => "Veiller à respecter la quantité d'eau selon le type de plante."
}

# types de récompenses/privilèges
AWARD_TYPES = [
  "Quotidien", "Hebdomadaire", "Mensuel"
]
# liste des récompenses/privilèges

AWARD_LIST = {
  Quotidien: [
    "Avoir un 'ticket pause' pour une tâche ou un moment stressant.",
    "Un câlin spécial ou une séance de chatouilles en famille.",
    "Jouer à un jeu vidéo avec un adulte.",
    "Une séance de dessin ou de peinture avec un parent.",
    "Avoir une soirée pyjama avec ses frères et sœurs.",
    "Passer un moment seul avec un parent pour une activité choisie.",
    "Lire une histoire supplémentaire au coucher.",
    "Un massage ou un moment de détente avec un parent.",
    "Choisir le repas ou le dessert du soir.",
    "Recevoir un mot ou une carte de félicitations écrite par les parents.",
    "Décorer sa chambre avec un nouvel objet.",
    "Jouer à cache-cache ou à une autre activité physique.",
    "Être dispensé d'une tâche ménagère pour une journée.",
    "Manger un goûter ou un dessert spécial.",
    "Pouvoir utiliser une tablette ou un écran pendant un temps supplémentaire.",

    ],
  Hebdomadaire: [
    "Aller faire une promenade spéciale (forêt, montagne, etc.).",
    "Regarder un film en famille avec des popcorns.",
    "Rester éveillé 30 minutes de plus un soir.",
    "Organiser une chasse au trésor en famille.",
    "Une séance de maquillage ou de déguisement.",
    "Prendre un bain avec des jouets ou des produits amusants.",
    "Organiser une soirée jeux de société en famille.",
    "Fabriquer un objet ou un bricolage ensemble.",
    "Construire une cabane dans le jardin ou le salon.",
    "Aller manger une glace ou un gâteau dans un café.",
    "Décider du programme télé ou du film du soir.",
    "Choisir une activité pour le week-end.",
    "Inviter un ami à dormir à la maison.",
    "Organiser une sortie à vélo en famille.",
    "Faire un pique-nique dans le jardin ou un parc.",
    "Porter un vêtement spécial ou un costume pour la journée.",
    "Préparer un repas ou un dessert spécial avec un parent.",
    "Organiser une visite à la librairie pour choisir un livre.",
  ],
  Mensuel: [
    "Organiser une sortie au parc d'attractions.",
    "Organiser une journée à la piscine ou à la plage.",
    "Organiser une visite au zoo ou à un aquarium.",
    "Organiser une mini fête ou un goûter spécial.",
    "Une balade à cheval ou un tour de poney.",
    "Aller à la fête foraine ou à un marché local.",
    "Aller au cinéma avec un parent ou un ami.",
    "Une promenade en bateau ou en pédalo.",
    "Une excursion pour observer les étoiles ou faire un feu de camp.",
    "Recevoir un carnet ou un cahier pour écrire ou dessiner.",
    "Recevoir un petit jouet ou gadget.",
    "Gagner un livre ou une bande dessinée.",
    "Obtenir un kit créatif (perles, pâte à modeler, etc.).",
    "Recevoir une plante ou une fleur à cultiver.",
    "Recevoir un ballon ou un frisbee pour jouer dehors.",
    "Recevoir une figurine ou une petite peluche.",

  ]
}
# Age mini pour l'appli
MIN_AGE = 4
# Age maxi pour l'appli
MAX_AGE = 16
# Age pour avoir accès soi-même
AGE_ACCOUNT = 9
# Les points qu'ils ont déjà
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
  Quotidien: MIN_POINTS_TASK / 3,
  Hebdomadaire: MIN_POINTS_TASK / 2,
  Mensuel: MIN_POINTS_TASK
}
# points maximum pour un(e) récompense/privilège
MAX_AWARD_POINTS = {
  Quotidien: MAX_POINTS_TASK / 3,
  Hebdomadaire: MAX_POINTS_TASK / 2,
  Mensuel: MAX_POINTS_TASK
}



puts "---Destroying all data"
User.destroy_all
Child.destroy_all
Family.destroy_all
Award.destroy_all
Task.destroy_all
TaskType.destroy_all


puts "---All data destroyed"

puts "---Creating the 7 TaskTypes"
TASK_TYPES.each do |type|
  TaskType.create!(name: type)
end
puts "--- Task_Types ( Animaux Apprentissage Chambre Cuisine Hygiène Linge Ménage ) CREATED"


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
    AWARD_TYPES.each do |award_type|
      [1,2].sample.to_i.times do
        award = Award.create!(child_id: child.id, name: AWARD_LIST[award_type.to_sym].sample, periodicity: award_type, value: (MIN_AWARD_POINTS[award_type.to_sym]..MAX_AWARD_POINTS[award_type.to_sym]).to_a.sample)
      end
    end
    4.times do
      task_type = TASK_TYPES.sample
      name = TASK_LIST[task_type.to_sym].sample
      Task.create!(child_id: child.id, task_type_id: TaskType.find_by(name: task_type).id, name: name, description: TASK_DESCRIPTIONS[name], value: (MIN_POINTS_TASK..MAX_POINTS_TASK).to_a.sample)
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


#puts "---Creating 50 other families"

#50.times do
#  family = Family.create!(name: Faker::Name.last_name)
 # first_name1 = Faker::Name.first_name
  #first_name2 = Faker::Name.first_name
  #user1 = User.create!(family_id: family.id, first_name: first_name1, last_name: family.name, email: Faker::Internet.email(name: first_name1), child: false, password: 'happyT')
  #user2 = User.create!(family_id: family.id, first_name: first_name2, last_name: family.name, email: Faker::Internet.email(name: first_name2), child: false, password: 'happyT')
  #create_the_rest(family)
#end
#puts "---50 Families CREATED"
