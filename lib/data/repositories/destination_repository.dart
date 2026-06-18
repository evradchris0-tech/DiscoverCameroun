// NOTE : Repository des destinations — point d'accès unique aux données de destination.
// Concept mis en avant : la couche présentation ignore d'où viennent les données (JSON/API).

import '../../models/destination.dart';
import '../datasources/local_json_datasource.dart';

class DestinationRepository {
  final LocalJsonDataSource _dataSource;
  const DestinationRepository(this._dataSource);

  static const _asset = 'assets/data/destinations.json';

  Future<List<Destination>> getAll() async {
    final raw = await _dataSource.loadRawList(_asset);
    return raw.map(Destination.fromJson).toList();
  }
}
