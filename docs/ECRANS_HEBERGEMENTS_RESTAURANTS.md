# 📄 Spécification — Écrans Hébergements & Restaurants (E5 / E6)

> Document de conception destiné à l'implémentation des écrans dédiés
> « Où dormir » (hébergements) et « Où manger » (restaurants) de Discover Cameroon.
> Statut : **à implémenter** (Sprint 2). Les données et les cartes existent déjà.

---

## 1. Contexte & état actuel

Aujourd'hui, les hébergements et restaurants **existent déjà** dans l'application :

- **Modèles** : [Accommodation](../lib/models/accommodation.dart), [Restaurant](../lib/models/restaurant.dart)
- **Données** : [accommodations.json](../assets/data/accommodations.json), [restaurants.json](../assets/data/restaurants.json) (clé étrangère `destinationId`)
- **Repositories + providers** : `accommodationsProvider` / `restaurantsProvider` et leurs variantes `...ForDestinationProvider(id)` dans [catalog_providers.dart](../lib/providers/catalog_providers.dart)
- **Cartes UI réutilisables** : [AccommodationCard](../lib/widgets/accommodation_card.dart), [RestaurantCard](../lib/widgets/restaurant_card.dart) — avec boutons **Itinéraire** (Google Maps) et **Appeler**.
- **Affichage actuel** : ces cartes apparaissent **en aperçu** dans la fiche destination (sections « Où dormir » / « Où manger ») via [DestinationRubrics](../lib/widgets/destination_rubrics.dart).

**Ce qu'il manque** : des **écrans dédiés** (listes complètes, filtres, tri) accessibles depuis la fiche destination (« Voir tout ») et, à terme, depuis un onglet ou un point d'entrée global.

---

## 2. Objectif des écrans dédiés

| | Hébergements | Restaurants |
|---|---|---|
| **But** | Trouver où dormir près d'une destination | Trouver où manger près d'une destination |
| **Entrée** | Bouton « Voir tout » de la section « Où dormir » | Bouton « Voir tout » de la section « Où manger » |
| **Donnée source** | `accommodationsForDestinationProvider(destinationId)` | `restaurantsForDestinationProvider(destinationId)` |
| **Tri** | Prix croissant / Note décroissante | Note décroissante / Gamme de prix |
| **Filtre** | Type (hôtel, auberge, campement…) | Cuisine (camerounaise, grillades…) |
| **Action carte** | Itinéraire + Appeler (déjà dans la carte) | Itinéraire + Appeler (déjà dans la carte) |

---

## 3. Architecture proposée (cohérente avec l'existant)

On suit **exactement** le patron déjà utilisé par [GuidesScreen](../lib/screens/guides_screen.dart) :
un `ConsumerWidget` qui prend `destinationId` + `destinationName`, observe le
`FutureProvider.family` correspondant, gère les états loading / error / empty, et
liste les cartes existantes.

```
lib/screens/
  accommodations_screen.dart   ← NOUVEAU  (AccommodationsScreen)
  restaurants_screen.dart      ← NOUVEAU  (RestaurantsScreen)
```

### 3.1 Squelette (hébergements)

```dart
class AccommodationsScreen extends ConsumerStatefulWidget {
  final String destinationId;
  final String destinationName;
  const AccommodationsScreen({
    super.key,
    required this.destinationId,
    required this.destinationName,
  });
  // ConsumerStatefulWidget car le tri/filtre est un état local.
}
```

État local :
```dart
AccommodationType? _typeFilter;      // null = tous les types
_SortMode _sort = _SortMode.priceAsc; // prix croissant par défaut
enum _SortMode { priceAsc, ratingDesc }
```

Pipeline d'affichage :
```dart
final async = ref.watch(accommodationsForDestinationProvider(widget.destinationId));
// 1. filtrer par _typeFilter
// 2. trier selon _sort
// 3. ListView de AccommodationCard(accommodation: a)
```

### 3.2 Squelette (restaurants)

Identique, en remplaçant :
- `accommodationsForDestinationProvider` → `restaurantsForDestinationProvider`
- filtre `AccommodationType` → filtre par **cuisine** (`String`, dérivé de `cuisines`)
- `AccommodationCard` → `RestaurantCard`

---

## 4. Maquette (ASCII)

```
┌─────────────────────────────────────┐
│ ←  Où dormir · Kribi                 │  AppBar (titre i18n)
├─────────────────────────────────────┤
│ [Tous] [Hôtel] [Auberge] [Campement] │  Filtre par type (FilterChip)
│ Trier : (Prix ▼) (Note)              │  Tri (chips ou menu)
├─────────────────────────────────────┤
│ ┌─────────────────────────────────┐ │
│ │ Tara Plage Hôtel       dès 35 000│ │
│ │ [Hôtel] ★4.5            / nuit   │ │  ← AccommodationCard (existant)
│ │ 📍 Bord de mer, Kribi            │ │
│ │ [Wifi][Piscine][Plage]          │ │
│ │ [ Itinéraire ]  [ Appeler ]     │ │
│ └─────────────────────────────────┘ │
│ ┌─────────────────────────────────┐ │
│ │ Ilomba Resort          dès 25 000│ │
│ │ ...                              │ │
│ └─────────────────────────────────┘ │
└─────────────────────────────────────┘
```

---

## 5. Navigation (branchement)

Dans [destination_rubrics.dart](../lib/widgets/destination_rubrics.dart), la section
« Où dormir » utilise aujourd'hui un `SectionHeader` sans action. Ajouter un
`actionLabel: l10n.actionSeeAll` + `onAction` quand la liste dépasse N éléments :

```dart
header: SectionHeader(
  title: l10n.sectionWhereToSleep,
  actionLabel: list.length > 2 ? l10n.actionSeeAll : null,
  onAction: list.length > 2
      ? () => Navigator.push(context, MaterialPageRoute(
          builder: (_) => AccommodationsScreen(
            destinationId: id,
            destinationName: destination.name,
          )))
      : null,
),
children: list.take(2).map(...).toList(),  // aperçu limité à 2
```

Idem pour « Où manger » → `RestaurantsScreen`.

---

## 6. Internationalisation (i18n)

Ajouter les clés suivantes dans [app_en.arb](../lib/l10n/app_en.arb) et
[app_fr.arb](../lib/l10n/app_fr.arb), puis `flutter gen-l10n` :

| Clé | FR | EN |
|---|---|---|
| `accommodationsTitle` | `Où dormir · {name}` | `Where to sleep · {name}` |
| `restaurantsTitle` | `Où manger · {name}` | `Where to eat · {name}` |
| `sortLabel` | `Trier` | `Sort` |
| `sortPriceAsc` | `Prix` | `Price` |
| `sortRating` | `Note` | `Rating` |
| `accommodationsEmpty` | `Aucun hébergement référencé.` | `No accommodation listed.` |
| `restaurantsEmpty` | `Aucun restaurant référencé.` | `No restaurant listed.` |

Les libellés de **type d'hébergement** (`AccommodationType.label`) restent à
localiser globalement (voir §8).

---

## 7. Design System (règles à respecter)

- **Aucune couleur hexa ni `GoogleFonts` en dur** : utiliser `AppColors`, `AppTypography`,
  `AppSpacing`, `AppRadius` (cf. [lib/theme/](../lib/theme/)).
- Réutiliser **`SectionHeader`**, **`AccommodationCard`**, **`RestaurantCard`** tels quels.
- États `loading` / `error` / `empty` traités comme dans `GuidesScreen`.

---

## 8. Limites connues & évolutions

1. **Photos** : `photoPaths` pointent vers `assets/images/accommodations/…` non encore
   fournis → fallback (icône/initiale). À remplacer par de vraies images.
2. **Localisation des enums** (`AccommodationType`, cuisines) : aujourd'hui en français
   en dur dans les extensions de modèle. Évolution : passer par une fonction de
   localisation `label(BuildContext)` ou des clés ARB.
3. **Tri par distance** : nécessite la position GPS de l'utilisateur (`geolocator`) —
   hors périmètre MVP, candidat Sprint 3.
4. **Réservation** : bouton « Réserver » (modèle de revenus par commission) — épic E12,
   post-concours.

---

## 9. Definition of Done

- [ ] `AccommodationsScreen` + `RestaurantsScreen` créés sur le modèle de `GuidesScreen`.
- [ ] Filtre (type / cuisine) + tri (prix / note) fonctionnels.
- [ ] Boutons « Voir tout » branchés depuis la fiche destination.
- [ ] Clés i18n ajoutées (FR/EN) et utilisées.
- [ ] `flutter analyze` : 0 issue ; 0 couleur/police en dur hors `theme/`.
```
