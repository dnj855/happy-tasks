require 'open-uri'
require 'json'
require 'faker'
require 'uri'
require 'net/http'
require 'date'

# URL email
URL_PATH = '@happy-tasks.click'
# Super users
BASE_USERS = [
  [{ first_name: "Guillaume", last_name: "Fournier", email: "gf#{URL_PATH}", password: "happyT"},
    { first_name: "Nelly", last_name: "Fournier", email: "nf#{URL_PATH}", password: "happyT"}],
  [{ first_name: "Hélène", last_name: "Demanet", email: "hd#{URL_PATH}", password: "happyT"},
    { first_name: "Pierre-Luc", last_name: "Demanet", email: "pld#{URL_PATH}", password: "happyT"}],
  [{ first_name: "Emilie", last_name: "Vennat-Louveau", email: "evl#{URL_PATH}", password: "happyT"},
    { first_name: "Xavier", last_name: "Vennat-Louveau", email: "xvl#{URL_PATH}", password: "happyT"}],
  [{ first_name: "Cédric", last_name: "Lang-Roth", email: "clr#{URL_PATH}", password: "happyT"},
    { first_name: "Vanessa", last_name: "Lang-Roth", email: "vlr#{URL_PATH}", password: "happyT"}]
]
# Types de tâches
TASK_TYPES = [
  "Chambre", "Linge", "Ménage", "Cuisine", "Animaux", "Apprentissage", "Hygiène"
]
# liste des tâches
TASK_LIST = {
  easy: {
    value: 10,
    task: {
      Chambre: ["Faire son lit", "Aérer la chambre", "Ranger ses jouets", "Faire la poussière"],
      Linge: ["Ranger le linge", "Apporter le linge", "Trier les chaussettes par paire", "Mettre le linge sale dans le panier"],
      Ménage: ["Passer l'aspirateur", "Passer le balai", "Essuyer une petite table ou un bureau", "Nettoyer les interrupteurs ou poignées de porte"],
      Cuisine: ["Mettre la table", "Débarrasser la table", "Apporter les condiments ou les boissons sur la table", "Aider à plier des serviettes ou des torchons"],
      Animaux: ["Nourrir les animaux", "Sortir les animaux", "Remplir l’eau des animaux", "Brosser doucement un animal sous supervision"],
      Apprentissage: ["Faire ses devoirs", "Pratiquer une activité", "Lire un livre ou une bande dessinée pendant un temps défini", "Apprendre à écrire une phrase ou à dessiner quelque chose de nouveau"],
      Hygiène: ["Se brosser les dents", "Faire sa toilette", "Ranger ses affaires de toilette après utilisation", "Plier et ranger sa serviette"]
    }
    },
  medium: {
    value: 20,
    task:{
      Chambre: ["Préparer sa chambre", "Réorganiser sa chambre", "Trier les objets inutiles ou cassés", "Changer les draps avec l'aide d'un parent"],
      Linge: ["Plier le linge", "Trier le linge", "Regrouper les vêtements d'une même catégorie (exemple: t-shirts)", "Repasser un petit linge facile avec assistance"],
      Ménage: ["Faire les vitres", "Enlever les toiles d'araignée", "Nettoyer une petite étagère ou bibliothèque", "Balayer la terrasse ou le balcon"],
      Cuisine: ["Débarrasser le lave-vaisselle", "Mettre au lave-vaisselle", "Trier les fruits et légumes pour la semaine", "Aider à préparer un goûter simple (comme éplucher une banane)" ],
      Animaux: [ "Entretenir les animaux", "Entretenir l'habitat", "Nettoyer un bol ou une gamelle", "Ranger les jouets ou accessoires de l'animal"],
      Apprentissage: ["Aider aux devoirs", "Arroser les plantes", "Ranger les livres ou fournitures dans un ordre spécifique", "Apprendre un geste écologique (recycler, économiser l'eau)"],
      Hygiène: ["Prendre sa douche", "Préparer ses vêtements du lendemain", "Nettoyer ses chaussures", "Vérifier et compléter son sac pour l'école"]
    }
    },
  hard: {
    value: 30,
    task:{
      Chambre: ["Ranger sa chambre", "Organiser son placard ou une étagère entière", "Aspirer sous le lit ou derrière un meuble"],
      Linge: ["Etendre le linge", "Trier les vêtements trop petits ou usés pour les donner", "Plier et ranger tous les draps et serviettes"],
      Ménage: ["Aspirer dans la voiture", "Laver les portes d'un meuble ou des placards de cuisine", "Dépoussiérer les ventilateurs ou grilles d'aération"],
      Cuisine: ["Cuisiner", "Aider à cuisiner un plat en suivant les consignes", "Préparer une salade ou une entrée simple"],
      Animaux: ["Préparer le transport", "Nettoyer la litière ou l'espace de vie d'un animal (sous supervision)", "Préparer une activité pour occuper l'animal (jeu, promenade)"],
      Apprentissage: ["Arroser les plantes", "Planter une graine ou une plante en pot", "Préparer un projet scolaire ou une présentation"],
      Hygiène: ["Se couper les ongles", "Trier ses affaires de toilette et jeter les produits vides", "Laver ses accessoires (brosse à cheveux, trousse de toilette)"]
    }
    }
  }

  # extrahard: Informatique: ["Débugguer l'application de maman ou papa"]


#"Action mystère : Carte bonus parent"

TASK_DESCRIPTIONS = {
  "Organiser son placard ou une étagère entière" => "Trier, ranger et optimiser l'espace dans le placard ou sur une grande étagère.",
  "Aspirer sous le lit ou derrière un meuble" => "Déplacer légèrement les meubles légers pour aspirer les zones souvent oubliées.",
  "Trier les vêtements trop petits ou usés pour les donner" => "Identifier les vêtements inutilisés ou trop petits et les mettre dans un sac pour les donner.",
  "Plier et ranger tous les draps et serviettes" => "Organiser les draps et serviettes dans une armoire dédiée.",
  "Laver les portes d'un meuble ou des placards de cuisine" => "Passer une éponge ou un chiffon humide sur les surfaces extérieures des placards.",
  "Dépoussiérer les ventilateurs ou grilles d'aération" => "Essuyer délicatement les pales d'un ventilateur ou les grilles avec un chiffon.",
  "Aider à cuisiner un plat en suivant les consignes" => "Participer à la préparation d'un plat simple en manipulant des ingrédients sous supervision.",
  "Préparer une salade ou une entrée simple" => "Laver et découper les légumes pour une salade ou une petite entrée.",
  "Nettoyer la litière ou l'espace de vie d'un animal (sous supervision)" => "Enlever les déchets, nettoyer l'espace et remettre des matériaux propres.",
  "Préparer une activité pour occuper l'animal (jeu, promenade)" => "Organiser un moment spécifique pour distraire ou promener l'animal.",
  "Planter une graine ou une plante en pot" => "Préparer le terreau, planter une graine et l'arroser.",
  "Préparer un projet scolaire ou une présentation" => "Organiser ses idées, dessiner ou rédiger en vue d'un devoir ou d'une présentation orale.",
  "Trier ses affaires de toilette et jeter les produits vides" => "Vérifier les produits et ranger ceux encore utilisables, en jetant les autres.",
  "Laver ses accessoires (brosse à cheveux, trousse de toilette)" => "Nettoyer ses objets personnels avec du savon et de l'eau.",
  "Trier les objets inutiles ou cassés" => "Examiner les affaires dans la chambre et décider des objets à jeter ou à recycler.",
  "Changer les draps avec l'aide d'un parent" => "Retirer les draps sales et mettre en place des draps propres sur le lit.",
  "Regrouper les vêtements d'une même catégorie (exemple: t-shirts)" => "Organiser les vêtements propres par type avant de les ranger.",
  "Repasser un petit linge facile avec assistance" => "Avec la supervision d'un adulte, lisser des vêtements simples comme une serviette ou un torchon.",
  "Nettoyer une petite étagère ou bibliothèque"=> "Retirer les livres ou objets, essuyer les surfaces, puis replacer les objets soigneusement.",
  "Balayer la terrasse ou le balcon" => "Utiliser un balai pour ramasser les feuilles ou la poussière sur une petite surface extérieure.",
  "Trier les fruits et légumes pour la semaine" => "Vérifier les fruits et légumes, séparer ceux à consommer rapidement et ranger les autres.",
  "Aider à préparer un goûter simple (comme éplucher une banane)" => "Participer à la préparation d'un en-cas en épluchant ou coupant des fruits faciles.",
  "Nettoyer un bol ou une gamelle" => "Laver le récipient de nourriture ou d'eau de l'animal avec du savon.",
  "Ranger les jouets ou accessoires de l'animal" => "Regrouper les jouets ou accessoires dans un espace dédié.",
  "Ranger les livres ou fournitures dans un ordre spécifique" => "Trier les livres par taille ou les fournitures par type et les mettre à leur place.",
  "Apprendre un geste écologique (recycler, économiser l'eau)" => "Comprendre et réaliser une action éco-responsable, comme trier les déchets ou couper l'eau après utilisation.",
  "Nettoyer ses chaussures" => "Enlever la poussière ou la boue des chaussures avec un chiffon ou une brosse.",
  "Vérifier et compléter son sac pour l'école" => "Préparer son cartable pour le lendemain en vérifiant les cahiers, les livres et le matériel.",
  "Ranger ses affaires de toilette après utilisation" => "Mettre brosse à dents, peigne ou serviette à leur place.",
  "Plier et ranger sa serviette" => "Replier la serviette propre ou utilisée et la poser à l'endroit dédié.",
  "Apprendre à écrire une phrase ou à dessiner quelque chose de nouveau" => "Écrire une courte phrase lisible ou dessiner un objet, un animal ou un personnage.",
  "Lire un livre ou une bande dessinée pendant un temps défini" => "Se concentrer sur une lecture simple pour découvrir une histoire ou des informations.",
  "Brosser doucement un animal sous supervision" => "Passer une brosse adaptée sur le pelage de l'animal pour le soigner.",
  "Remplir l'eau des animaux" => "Vérifier que les animaux ont de l'eau fraîche et remplir leur bol si nécessaire.",
  "Aider à plier des serviettes ou des torchons" => "Prendre des serviettes propres ou des torchons et les plier proprement.",
  "Apporter les condiments ou les boissons sur la table" => "Transporter le sel, le poivre, les sauces ou les boissons nécessaires pour le repas.",
  "Nettoyer les interrupteurs ou poignées de porte" => "Désinfecter ou essuyer délicatement ces surfaces pour les garder propres.",
  "Essuyer une petite table ou un bureau" => "Utiliser un chiffon humide ou sec pour nettoyer la surface d'une petite table.",
  "Trier les chaussettes par paire" => "Regrouper toutes les chaussettes propres et les associer par couleur ou motif.",
  "Mettre le linge sale dans le panier" => "Ramasser tous les vêtements usés et les déposer dans le panier à linge.",
  "Aspirer dans la voiture" => "Passer l'aspirateur pour enlever la poussière et les saletés.",
  "Entretenir l'habitat" => "Nettoyer l'espace de l'animal, changer l'eau, vérifier son confort, etc.",
  "Faire sa toilette" => "Se laver le visage, les mains, et se coiffer pour être propre et frais.",
  "Préparer ses vêtements du lendemain" => "Choisir des vêtements propres adaptés au lendemain pour gagner du temps.",
  "Préparer le transport" => "Faire en sorte que le moyen de transport (cage, laisse, etc.) et la nourriture soient prêts.",
  "Enlever les toiles d'araignée" => "Faire le tour de la maison et enlever les toiles d'araignée les plus gênantes.",
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
  "Arroser les plantes" => "Veiller à respecter la quantité d'eau selon le type de plante.",
  "Ranger ses jouets" => "Mettre tous les jouets éparpillés dans leurs boîtes respectives ou les ranger sur une étagère.",
  "Faire la poussière" => "Passer un chiffon doux sur un meuble ou un bureau pour enlever la poussière.",
  #"Débugguer l'application de maman ou papa" => "faire planter la connexion du type de l'autre groupe qui a fait un ticket avec le prof"
}

# types de récompenses/privilèges
AWARD_TYPES = [
  "Quotidien", "Hebdomadaire", "Mensuel"
]
# liste des récompenses/privilèges

#Il y a deux type d'awards pour quotidien/hebdomadaire/mensuel (automatic: et random:)
# et 3 niveaux d'obtention pour random (easy:, medium:, hard: )
# automatic: [array des awards à donner automatiquement] random: [array des autres awards à donner]
# les awards automatic: coutent le minimum de points, elles sont donc de niveau 'easy'
# les awards random: ont 3 niveaux : easy:, medium:, hard: (et extra: en mensuel)
AWARD_LIST = {
  Quotidien: {
    automatic: {
      value: 10,
      description:[
      "Passer un moment seul avec un parent pour une activité choisie."
      ]},
    random: {
      easy: {
        value: 10,
        description:[
        "Lire une histoire supplémentaire au coucher.",
        "Une séance de dessin ou de peinture avec un parent.",
        "Avoir un 'ticket pause' pour une tâche ou un moment stressant.",
        "Un câlin spécial ou une séance de chatouilles en famille.",
        "Choisir le repas ou le dessert du soir."
        ]},
      medium: {
        value: 20,
        description:[
        "Recevoir un mot ou une carte de félicitations écrite par les parents.",
        "Un massage ou un moment de détente avec un parent.",
        "Jouer à cache-cache ou à une autre activité physique.",
        "Manger un goûter ou un dessert spécial.",
        "Pouvoir utiliser une tablette ou un écran pendant un temps supplémentaire."
        ]},
      hard: {
        value: 30,
        description:[
        "Avoir une soirée pyjama avec ses frères et sœurs.",
        "Décorer sa chambre avec un nouvel objet.",
        "Être dispensé d'une tâche ménagère pour une journée.",
        "Jouer à un jeu vidéo avec un adulte."
        ]}
    }
  },
  Hebdomadaire: {
    automatic: {
      value: 50,
      description:[
      ]},
    random: {
      easy: {
        value: 50,
        description:[
        "Avoir une soirée pyjama avec ses frères et sœurs.",
        "Décorer sa chambre avec un nouvel objet.",
        "Être dispensé d'une tâche ménagère pour une journée.",
        "Jouer à un jeu vidéo avec un adulte.",
        "Rester éveillé 30 minutes de plus un soir.",
        "Organiser une chasse au trésor en famille.",
        "Organiser une séance de maquillage ou de déguisement.",
        "Prendre un bain avec des jouets ou des produits amusants.",
        "Organiser une soirée jeux de société en famille.",
        "Décider du programme télé ou du film du soir."]},
      medium: {
        value: 80,
        description:[
        "Fabriquer un objet ou un bricolage ensemble.",
        "Construire une cabane dans le jardin ou le salon.",
        "Aller manger une glace ou un gâteau dans un café.",
        "Choisir une activité pour le week-end.",
        "Porter un vêtement spécial ou un costume pour la journée.",
        "Préparer un repas ou un dessert spécial avec un parent.",
        "Organiser une visite à la librairie pour choisir un livre."]},
      hard: {
        value: 120,
        description:[
        "Regarder un film en famille avec des popcorns.",
        "Aller faire une promenade spéciale (forêt, montagne, etc.).",
        "Inviter un ami à dormir à la maison.",
        "Organiser une sortie à vélo en famille.",
        "Faire un pique-nique dans le jardin ou un parc.",]}
    }
  },
  Mensuel: {
    automatic: {
      value: 150,
      description:[]},
    random: {
      easy: {
        value: 150,
        description:[
        "Regarder un film en famille avec des popcorns.",
        "Aller faire une promenade spéciale (forêt, montagne, etc.).",
        "Inviter un ami à dormir à la maison.",
        "Organiser une sortie à vélo en famille.",
        "Faire un pique-nique dans le jardin ou un parc.",
        "Organiser une mini fête ou un goûter spécial."]},
        medium: {
          value: 300,
          description:[
          "Une promenade en bateau ou en pédalo.",
          "Une excursion pour observer les étoiles ou faire un feu de camp.",
          "Recevoir un carnet ou un cahier pour écrire ou dessiner.",
          "Aller au cinéma avec un parent ou un ami."]},
        hard: {
          value: 500,
          description:[
          "Aller à la fête foraine ou à un marché local.",
          "Recevoir un petit jouet ou gadget.",
          "Gagner un livre ou une bande dessinée.",
          "Obtenir un kit créatif (perles, pâte à modeler, etc.).",
          "Organiser une balade à cheval ou un tour de poney."]},
        extra: {
          value: 800,
          description:[
          "Recevoir une plante ou une fleur à cultiver.",
          "Recevoir un ballon ou un frisbee pour jouer dehors.",
          "Recevoir une figurine ou une petite peluche.",
          "Organiser une sortie au parc d'attractions.",
          "Organiser une journée à la piscine ou à la plage.",
          "Organiser une visite au zoo ou à un aquarium.",]}
    }
  }
}

TASK_RECORD = []

# Age mini pour l'appli
MIN_AGE = 4
# Age maxi pour l'appli
MAX_AGE = 16
# Age pour avoir accès soi-même
AGE_ACCOUNT = 9
# Les points qu'ils ont déjà
MIN_WEEK_POINTS = 50
MAX_WEEK_POINTS = 120
MIN_MONTH_POINTS = 150
MAX_MONTH_POINTS = 500

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
      list_of_awards = []
      list_of_tasks = []
        child = Child.create!(
          family_id: family.id,
          first_name: Faker::Name.first_name,
          age: (MIN_AGE..MAX_AGE).to_a.sample,
          day_points: 0,
          week_points: 0,
          month_points: 0,)
        if child.age >= AGE_ACCOUNT
          User.create!(family_id: family.id, first_name: child.first_name, last_name: family.name, email: "#{child.first_name}#{family.id}#{URL_PATH}", password: "happyT", child_id = child.id)
        end
        # array list_of_awards

        # les awards quotidiennes automatiques
        AWARD_LIST[:Quotidien][:automatic][:description].each do |description|
          award = Award.create!(child_id: child.id, name: description, periodicity: "Quotidien", value: AWARD_LIST[:Quotidien][:automatic][:value])
          list_of_awards << description
        end
        # les awards quotidiennes random
        # 1 EASY
          award = Award.create!(child_id: child.id, name: AWARD_LIST[:Quotidien][:random][:easy][:description].sample, periodicity: "Quotidien", value: AWARD_LIST[:Quotidien][:random][:easy][:value])
          list_of_awards << award.name
        # 2 MEDIUM
        while list_of_awards.length !=4 do
          awa=''
          awa=AWARD_LIST[:Quotidien][:random][:medium][:description].sample
          if !list_of_awards.include?(awa)
            award = Award.create!(child_id: child.id, name: awa, periodicity: "Quotidien", value: AWARD_LIST[:Quotidien][:random][:medium][:value])
            list_of_awards << award.name
          end
        end
            # 1 HARD
        while list_of_awards.length !=5 do
          awa=''
          awa=AWARD_LIST[:Quotidien][:random][:hard][:description].sample
          if !list_of_awards.include?(awa)
            award = Award.create!(child_id: child.id, name: awa, periodicity: "Quotidien", value: AWARD_LIST[:Quotidien][:random][:hard][:value])
            list_of_awards << award.name
          end
        end
        # les awards hebdomadaires automatic
        # aucune pour le moment
        # les awards hebdomadaires random
        # 2 EASY
        while list_of_awards.length !=7 do
          awa=''
          awa=AWARD_LIST[:Hebdomadaire][:random][:easy][:description].sample
          if !list_of_awards.include?(awa)
            award = Award.create!(child_id: child.id, name: awa, periodicity: "Hebdomadaire", value: AWARD_LIST[:Hebdomadaire][:random][:easy][:value])
            list_of_awards << award.name
          end
        end
        # 2 MEDIUM
        while list_of_awards.length !=9 do
          awa=''
          awa=AWARD_LIST[:Hebdomadaire][:random][:medium][:description].sample
          if !list_of_awards.include?(awa)
            award = Award.create!(child_id: child.id, name: awa, periodicity: "Hebdomadaire", value: AWARD_LIST[:Hebdomadaire][:random][:medium][:value])
            list_of_awards << award.name
          end
        end
        # 1 HARD
        while list_of_awards.length !=10 do
          awa=''
          awa=AWARD_LIST[:Hebdomadaire][:random][:hard][:description].sample
          if !list_of_awards.include?(awa)
            award = Award.create!(child_id: child.id, name: awa, periodicity: "Hebdomadaire", value: AWARD_LIST[:Hebdomadaire][:random][:hard][:value])
            list_of_awards << award.name
          end
        end
        # les awards mensuelles automatiques
        # aucune pour le moment
        # les awards mensuelles random
        # 2 EASY
        while list_of_awards.length !=12 do
          awa=''
          awa=AWARD_LIST[:Mensuel][:random][:easy][:description].sample
          if !list_of_awards.include?(awa)
            award = Award.create!(child_id: child.id, name: awa, periodicity: "Mensuel", value: AWARD_LIST[:Mensuel][:random][:easy][:value])
            list_of_awards << award.name
          end
        end
        # 2 MEDIUM
        while list_of_awards.length !=14 do
          awa=''
          awa=AWARD_LIST[:Mensuel][:random][:medium][:description].sample
          if !list_of_awards.include?(awa)
            award = Award.create!(child_id: child.id, name: awa, periodicity: "Mensuel", value: AWARD_LIST[:Mensuel][:random][:medium][:value])
            list_of_awards << award.name
          end
        end
        # 1 HARD
        while list_of_awards.length !=15 do
          awa=''
          awa=AWARD_LIST[:Mensuel][:random][:hard][:description].sample
          if !list_of_awards.include?(awa)
            award = Award.create!(child_id: child.id, name: awa, periodicity: "Mensuel", value: AWARD_LIST[:Mensuel][:random][:hard][:value])
            list_of_awards << award.name
          end
        end
        # 1 EXTRA
        while list_of_awards.length !=16 do
          awa=''
          awa=AWARD_LIST[:Mensuel][:random][:extra][:description].sample
          if !list_of_awards.include?(awa)
            award = Award.create!(child_id: child.id, name: awa, periodicity: "Mensuel", value: AWARD_LIST[:Mensuel][:random][:extra][:value])
            list_of_awards << award.name
          end
        end

        # on veut 2 tâches easy, 2 tâches medium et 1 tâche hard
        # pour éviter d'avoir deux taches identiques on crée un array list_of_tasks[]
first_december = Date.new(2024,12,01)
      for day in 0..17 do

          list_of_tasks = []
        while list_of_tasks.length !=2 do
          ta=''

          task_type = TASK_TYPES.sample

          ta = TASK_LIST[:easy][:task][task_type.to_sym].sample
          if !list_of_tasks.include?(ta)
            task = Task.create!(child_id: child.id, task_type_id: TaskType.find_by(name: task_type).id, name: ta, description: TASK_DESCRIPTIONS[ta], value: TASK_LIST[:easy][:value])
            task.update(created_at: first_december.next_day(day.to_i))
            list_of_tasks << task
          end
        end
        while list_of_tasks.length !=4 do
          ta=''
          task_type = TASK_TYPES.sample
          ta = TASK_LIST[:medium][:task][task_type.to_sym].sample
          if !list_of_tasks.include?(ta)
            task = Task.create!(child_id: child.id, task_type_id: TaskType.find_by(name: task_type).id, name: ta, description: TASK_DESCRIPTIONS[ta], value: TASK_LIST[:medium][:value])
            task.update(created_at: first_december.next_day(day.to_i))
            list_of_tasks << task
          end
        end
        while list_of_tasks.length !=5 do
          ta=''
          task_type = TASK_TYPES.sample
          ta = TASK_LIST[:hard][:task][task_type.to_sym].sample
          if !list_of_tasks.include?(ta)
            task = Task.create!(child_id: child.id, task_type_id: TaskType.find_by(name: task_type).id, name: ta, description: TASK_DESCRIPTIONS[ta], value: TASK_LIST[:hard][:value])
            task.update(created_at: first_december.next_day(day.to_i))
            list_of_tasks << task
          end
        end
        ### création de tâches validées (3/4)
        list_of_tasks.each do |task|
          if rand(4) != 0
            task.update(done: true)
            child.week_points += task.value/3.0

            child.month_points += task.value/3.0
            child.update(week_points: child.week_points)
            # reset des points de la semaine
            child.update(week_points: 0) if day == 15
            child.update(month_points: child.month_points)
            TASK_RECORD << {"id" => child.id, "tasks" => ["done_date" => first_december.next_day(day.to_i), "task_type" => task.task_type_id, task_name: task.name]}
          end
        end
      end
    end
  end



puts "---Creating base users"
BASE_USERS.each do |base_user|
  family = Family.create!(name: base_user[0][:last_name])
  User.create!(family_id: family.id, first_name: base_user[0][:first_name], last_name: base_user[0][:last_name], email: base_user[0][:email], child: base_user[0][:child], password: base_user[0][:password])
  User.create!(family_id: family.id, first_name: base_user[1][:first_name], last_name: base_user[1][:last_name], email: base_user[1][:email], child: base_user[1][:child], password: base_user[1][:password])
  create_the_rest(family)
end
puts "---Base users CREATED"


array_of_tasks = []


first_child = TASK_RECORD.select {|child| child.values_at("id")[0] == Child.all.first.id}



first_child.each do |task|
  array_of_tasks << task.values_at("tasks")[0][0]

  end
ménage = []
linge = []
apprentissage = []
cuisine = []
hygiène = []
chambre = []
animaux = []



array_of_tasks.each do |task|
  case TaskType.all.find(task.values_at("task_type"))[0].name
  when "Ménage"
    ménage << task.values_at("task_name")
  when "Animaux"
    animaux << task.values_at("task_name")
  when "Apprentissage"
    apprentissage << task.values_at("task_name")
  when "Cuisine"
    cuisine << task.values_at("task_name")
  when "Hygiène"
    hygiène << task.values_at("task_name")
  when "Linge"
    linge << task.values_at("task_name")
  when "Chambre"
    chambre << task.values_at("task_name")
  end
end

print "\n\n-------------rapport d'activité du premier child-------------------\n\n"
print "mén : "
print "ooooo"*ménage.length
print "\nlin : "
print "ooooo"*linge.length
print "\napp : "
print "ooooo"*apprentissage.length
print "\ncui : "
print "ooooo"*cuisine.length
print "\nhyg : "
print "ooooo"*hygiène.length
print "\ncha : "
print "ooooo"*chambre.length
print "\nani : "
print "ooooo"*animaux.length
print "\n\n------------ fin rapport d'activité du premier child-------------------\n\n"
print "------------- ses points en cagnotte------------------ \n"
print " Points de semaine : #{Child.all.first.week_points}\n"
print " Points du mois : #{Child.all.first.month_points}\n"
