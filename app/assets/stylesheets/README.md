# Documentation du Design System

## Introduction

Ce guide vous permettra d'utiliser efficacement notre design system pour créer des composants CSS cohérents. Il est conçu pour être accessible aux développeurs débutants et utilise la méthodologie BEM pour le nommage des classes.

## Table des matières

1. [Utilisation des couleurs](#utilisation-des-couleurs)
2. [Typographie](#typographie)
3. [Espacement](#espacement)
4. [Cards](#cards)
5. [Mise en page](#mise-en-page)
6. [Composants interactifs](#composants-interactifs)
7. [Responsivité](#responsivite)
8. [Animations](#animations)
9. [Utilitaires](#utilitaires)

## Utilisation des couleurs

Notre système de couleurs utilise des palettes prédéfinies avec différentes tonalités. Chaque palette contient cinq variations : lighter, light, base, dark, et darker.

### Comment utiliser les couleurs

Pour utiliser une couleur, utilisez la fonction `color()` avec deux paramètres :

1. Le nom de la palette
2. La tonalité (optionnelle, par défaut "base")

```scss
.element {
  // Utilisation basique
  color: color("primary"); // Utilise la tonalité "base"

  // Utilisation avec une tonalité spécifique
  background-color: color("primary", "light");
}
```

### Palettes disponibles

- primary (#146a8a)
- green (#06d6a0)
- red (#b9174a)
- yellow (#ffd166)
- blue (#48a7f8)
- dark (#404446)
- light (#f2f4f5)

## Typographie

Notre système typographique utilise deux familles de polices principales : "Sour Gummy" pour les titres et "Nunito Sans" pour le texte courant.

### Mixins typographiques

#### Pour les titres

```scss
// Utilisation basique
.titre {
  @include heading(); // Utilise la taille "base"
}

// Avec une taille spécifique
.grand-titre {
  @include heading("4xl"); // Tailles disponibles : xs à 4xl
}
```

#### Pour le texte courant

```scss
.texte {
  @include body-text(); // Taille et poids par défaut
}

// Avec taille et poids spécifiques
.texte-important {
  @include body-text("lg", "bold");
}
```

### Tailles de police disponibles

- xs: 12px
- sm: 14px
- base: 16px
- lg: 18px
- xl: 20px
- 2xl: 24px
- 3xl: 30px
- 4xl: 36px

## Espacement

Notre système utilise une échelle d'espacement cohérente. Utilisez la fonction `spacing()` pour maintenir cette cohérence.

### Utilisation basique

```scss
.element {
  padding: spacing("base"); // 1rem (16px)
  margin-bottom: spacing("lg"); // 1.25rem (20px)
}
```

### Multiplication d'espacement

Pour des espacements plus grands, utilisez la fonction `spacing-multiply()` :

```scss
.section {
  padding: spacing-multiply("base", 2); // Double l'espacement de base
}
```

### Valeurs d'espacement disponibles

- 2xs: 4px
- xs: 8px
- sm: 12px
- base: 16px
- lg: 20px
- xl: 24px
- 2xl: 32px
- 3xl: 40px
- 4xl: 48px

## Mise en page

Notre système inclut plusieurs mixins pour faciliter la mise en page avec Flexbox.

### Mixins de mise en page disponibles

```scss
// Centrage complet
.element {
  @include flex-center;
}

// Espacement entre les éléments
.container {
  @include flex-between;
}

// Direction colonne
.liste {
  @include flex-column;
}

// Autres options disponibles :
// @include flex-start;
// @include flex-end;
// @include flex-around;
// @include flex-evenly;
```

### Container principal

Pour créer un conteneur responsive avec des marges automatiques :

```scss
.section {
  @include container;
}
```

## Cards

### Border Radius

Notre design system offre une fonction dédiée `radius()` pour gérer les rayons de bordure de manière cohérente. Cette fonction simplifie l'accès aux valeurs prédéfinies de border-radius sans avoir besoin d'utiliser directement `map-get`.

```scss
// Utilisation simple
.element {
  border-radius: radius("base");
}

// Dans un composant plus complexe
.card {
  // Carte avec coins modérément arrondis
  border-radius: radius("lg");

  &__image {
    // Image avec coins plus arrondis
    border-radius: radius("xl");
  }

  &__button {
    // Bouton complètement arrondi
    border-radius: radius("full");
  }
}
```

Les valeurs disponibles pour la fonction `radius()` sont :

- `none` : 0
- `sm` : 0.125rem (2px)
- `base` : 0.25rem (4px)
- `md` : 0.375rem (6px)
- `lg` : 0.5rem (8px)
- `xl` : 0.75rem (12px)
- `2xl` : 1rem (16px)
- `full` : 9999px (pour faire des cercles parfaits)

### Shadows

Une fonction `shadow()` existe également pour gérer les box-shadows. Elle fonctionne de la même façon. Voici les valeurs disponibles :

- `sm`
- `base`
- `md`
- `lg`

## Composants interactifs

### Boutons

Pour créer un bouton conforme au design system :

```scss
.button {
  @include button-primary;
}

// Pour un bouton de base sans style
.button-custom {
  @include button-base;
  // Ajoutez vos styles personnalisés ici
}
```

### Champs de formulaire

Pour les champs de formulaire :

```scss
.input {
  @include input-base;
}
```

## Responsivité

Notre système utilise des breakpoints prédéfinis pour gérer la responsivité.

### Utilisation des mixins responsives

```scss
.element {
  // Style par défaut (mobile)
  width: 100%;

  // Style pour les tablettes et plus
  @include responsive("md") {
    width: 50%;
  }

  // Style jusqu'à une certaine taille
  @include until("lg") {
    padding: spacing("sm");
  }
}
```

### Breakpoints disponibles

- xs: 320px
- sm: 640px
- md: 768px
- lg: 1024px
- xl: 1280px
- 2xl: 1536px

## Animations

Notre système inclut des animations prédéfinies pour des transitions fluides.

### Fade In

```scss
.element {
  @include fade-in;
}
```

### Slide In

```scss
.element {
  @include slide-in("up"); // Directions disponibles : up, down, left, right

  // Avec une distance personnalisée
  @include slide-in("up", 30px);
}
```

## Utilitaires

### Troncature de texte

```scss
.texte-long {
  @include truncate;
}
```

### Masquer la scrollbar

```scss
.container-scroll {
  @include scrollbar-hidden;
}
```

## Exemples d'utilisation avec BEM

Voici comment utiliser le design system avec la méthodologie BEM :

```scss
.card {
  @include card-base;

  &__title {
    @include heading("xl");
    margin-bottom: spacing("base");
  }

  &__content {
    @include body-text("base");
  }

  &__button {
    @include button-primary;
    margin-top: spacing("lg");
  }

  &--featured {
    background-color: color("primary", "lighter");
  }
}
```

## Conseils pour les débutants

1. Commencez toujours par intégrer les mixins de base avant d'ajouter des personnalisations.
2. Utilisez les fonctions de couleur et d'espacement plutôt que des valeurs codées en dur.
3. Pensez "mobile first" en utilisant les mixins responsives.
4. Suivez la méthodologie BEM pour garder votre code propre et maintenable.
