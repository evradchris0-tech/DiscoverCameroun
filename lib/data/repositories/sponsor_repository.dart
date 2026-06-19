// NOTE : Repository des partenaires / sponsors.

import '../../models/sponsor.dart';
import '../datasources/local_json_datasource.dart';

class SponsorRepository {
  final LocalJsonDataSource _dataSource;
  const SponsorRepository(this._dataSource);

  static const _asset = 'assets/data/sponsors.json';

  Future<List<Sponsor>> getAll() async {
    final raw = await _dataSource.loadRawList(_asset);
    return raw.map(Sponsor.fromJson).toList();
  }
}
