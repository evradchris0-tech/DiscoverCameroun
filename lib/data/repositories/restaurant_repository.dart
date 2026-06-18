// NOTE : Repository des restaurants.

import '../../models/restaurant.dart';
import '../datasources/local_json_datasource.dart';

class RestaurantRepository {
  final LocalJsonDataSource _dataSource;
  const RestaurantRepository(this._dataSource);

  static const _asset = 'assets/data/restaurants.json';

  Future<List<Restaurant>> getAll() async {
    final raw = await _dataSource.loadRawList(_asset);
    return raw.map(Restaurant.fromJson).toList();
  }

  Future<List<Restaurant>> getForDestination(String destinationId) async {
    final all = await getAll();
    return all.where((r) => r.destinationId == destinationId).toList();
  }
}
