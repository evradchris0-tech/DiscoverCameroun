// NOTE : Repository des expériences touristiques.

import '../../models/tourist_experience.dart';
import '../datasources/local_json_datasource.dart';

class ExperienceRepository {
  final LocalJsonDataSource _dataSource;
  const ExperienceRepository(this._dataSource);

  static const _asset = 'assets/data/experiences.json';

  Future<List<TouristExperience>> getAll() async {
    final raw = await _dataSource.loadRawList(_asset);
    return raw.map(TouristExperience.fromJson).toList();
  }

  Future<List<TouristExperience>> getForDestination(
      String destinationId) async {
    final all = await getAll();
    return all.where((e) => e.destinationId == destinationId).toList();
  }
}
