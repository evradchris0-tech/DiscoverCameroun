// NOTE : Câblage de l'injection de dépendances via Riverpod.
// Concept mis en avant : un seul endroit déclare la source de données et les repositories ;
// remplacer LocalJsonDataSource par une source API ne touchera que ce fichier.

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/datasources/local_json_datasource.dart';
import '../data/repositories/accommodation_repository.dart';
import '../data/repositories/destination_repository.dart';
import '../data/repositories/emergency_repository.dart';
import '../data/repositories/experience_repository.dart';
import '../data/repositories/guide_repository.dart';
import '../data/repositories/restaurant_repository.dart';

/// Source de données bas-niveau (JSON local aujourd'hui).
final localJsonDataSourceProvider =
    Provider<LocalJsonDataSource>((ref) => const LocalJsonDataSource());

final destinationRepositoryProvider = Provider<DestinationRepository>(
  (ref) => DestinationRepository(ref.watch(localJsonDataSourceProvider)),
);

final guideRepositoryProvider = Provider<GuideRepository>(
  (ref) => GuideRepository(ref.watch(localJsonDataSourceProvider)),
);

final accommodationRepositoryProvider = Provider<AccommodationRepository>(
  (ref) => AccommodationRepository(ref.watch(localJsonDataSourceProvider)),
);

final restaurantRepositoryProvider = Provider<RestaurantRepository>(
  (ref) => RestaurantRepository(ref.watch(localJsonDataSourceProvider)),
);

final experienceRepositoryProvider = Provider<ExperienceRepository>(
  (ref) => ExperienceRepository(ref.watch(localJsonDataSourceProvider)),
);

final emergencyRepositoryProvider = Provider<EmergencyRepository>(
  (ref) => EmergencyRepository(ref.watch(localJsonDataSourceProvider)),
);
