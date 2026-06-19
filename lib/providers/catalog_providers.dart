// NOTE : Providers des rubriques touristiques (guides, hébergements, restaurants,
// expériences, urgences) + variantes « par destination » via Provider.family.
// Concept mis en avant : FutureProvider.family pour charger les données liées à un id.

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/accommodation.dart';
import '../models/emergency_contact.dart';
import '../models/restaurant.dart';
import '../models/sponsor.dart';
import '../models/tour_guide.dart';
import '../models/tourist_experience.dart';
import 'repository_providers.dart';

// --- Listes complètes ----------------------------------------------------

final guidesProvider = FutureProvider<List<TourGuide>>(
  (ref) => ref.watch(guideRepositoryProvider).getAll(),
);

final accommodationsProvider = FutureProvider<List<Accommodation>>(
  (ref) => ref.watch(accommodationRepositoryProvider).getAll(),
);

final restaurantsProvider = FutureProvider<List<Restaurant>>(
  (ref) => ref.watch(restaurantRepositoryProvider).getAll(),
);

final experiencesProvider = FutureProvider<List<TouristExperience>>(
  (ref) => ref.watch(experienceRepositoryProvider).getAll(),
);

final emergencyContactsProvider = FutureProvider<List<EmergencyContact>>(
  (ref) => ref.watch(emergencyRepositoryProvider).getAll(),
);

final sponsorsProvider = FutureProvider<List<Sponsor>>(
  (ref) => ref.watch(sponsorRepositoryProvider).getAll(),
);

// --- Variantes filtrées par destination ----------------------------------

final guidesForDestinationProvider =
    FutureProvider.family<List<TourGuide>, String>(
  (ref, destinationId) =>
      ref.watch(guideRepositoryProvider).getForDestination(destinationId),
);

final accommodationsForDestinationProvider =
    FutureProvider.family<List<Accommodation>, String>(
  (ref, destinationId) => ref
      .watch(accommodationRepositoryProvider)
      .getForDestination(destinationId),
);

final restaurantsForDestinationProvider =
    FutureProvider.family<List<Restaurant>, String>(
  (ref, destinationId) =>
      ref.watch(restaurantRepositoryProvider).getForDestination(destinationId),
);

final experiencesForDestinationProvider =
    FutureProvider.family<List<TouristExperience>, String>(
  (ref, destinationId) =>
      ref.watch(experienceRepositoryProvider).getForDestination(destinationId),
);
