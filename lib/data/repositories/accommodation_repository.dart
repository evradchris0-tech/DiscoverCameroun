// NOTE : Repository des hébergements.

import '../../models/accommodation.dart';
import '../datasources/local_json_datasource.dart';

class AccommodationRepository {
  final LocalJsonDataSource _dataSource;
  const AccommodationRepository(this._dataSource);

  static const _asset = 'assets/data/accommodations.json';

  Future<List<Accommodation>> getAll() async {
    final raw = await _dataSource.loadRawList(_asset);
    return raw.map(Accommodation.fromJson).toList();
  }

  Future<List<Accommodation>> getForDestination(String destinationId) async {
    final all = await getAll();
    return all.where((a) => a.destinationId == destinationId).toList();
  }
}
