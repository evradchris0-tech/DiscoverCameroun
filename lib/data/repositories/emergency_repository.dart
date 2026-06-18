// NOTE : Repository des contacts d'urgence.

import '../../models/emergency_contact.dart';
import '../datasources/local_json_datasource.dart';

class EmergencyRepository {
  final LocalJsonDataSource _dataSource;
  const EmergencyRepository(this._dataSource);

  static const _asset = 'assets/data/emergency_contacts.json';

  Future<List<EmergencyContact>> getAll() async {
    final raw = await _dataSource.loadRawList(_asset);
    return raw.map(EmergencyContact.fromJson).toList();
  }
}
