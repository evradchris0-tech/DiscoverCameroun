// NOTE : Repository des guides touristiques locaux.

import '../../models/tour_guide.dart';
import '../datasources/local_json_datasource.dart';

class GuideRepository {
  final LocalJsonDataSource _dataSource;
  const GuideRepository(this._dataSource);

  static const _asset = 'assets/data/guides.json';

  Future<List<TourGuide>> getAll() async {
    final raw = await _dataSource.loadRawList(_asset);
    return raw.map(TourGuide.fromJson).toList();
  }

  /// Guides couvrant une destination donnée.
  Future<List<TourGuide>> getForDestination(String destinationId) async {
    final all = await getAll();
    return all
        .where((g) => g.destinationIds.contains(destinationId))
        .toList();
  }
}
