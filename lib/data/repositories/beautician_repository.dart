import '../../domain/models/beautician_model.dart';
import '../datasources/in_memory_store.dart';

abstract class BeauticianRepository {
  Future<List<BeauticianModel>> getBeauticians({bool? onlyActive});
  Future<BeauticianModel?> getBeauticianById(String id);
  Future<void> createBeautician(BeauticianModel beautician);
  Future<void> updateBeautician(BeauticianModel beautician);
  Future<void> deleteBeautician(String id);
}

class MockBeauticianRepository implements BeauticianRepository {
  final InMemoryStore _store;

  MockBeauticianRepository({InMemoryStore? store})
    : _store = store ?? InMemoryStore.instance;

  @override
  Future<List<BeauticianModel>> getBeauticians({bool? onlyActive}) async {
    return _store.beauticians.where((b) {
      if (onlyActive == true && !b.isActive) return false;
      return true;
    }).toList();
  }

  @override
  Future<BeauticianModel?> getBeauticianById(String id) async {
    final index = _store.beauticians.indexWhere((b) => b.id == id);
    return index != -1 ? _store.beauticians[index] : null;
  }

  @override
  Future<void> createBeautician(BeauticianModel beautician) async {
    _store.beauticians.add(beautician);
  }

  @override
  Future<void> updateBeautician(BeauticianModel beautician) async {
    final index = _store.beauticians.indexWhere((b) => b.id == beautician.id);
    if (index != -1) {
      _store.beauticians[index] = beautician;
    }
  }

  @override
  Future<void> deleteBeautician(String id) async {
    _store.beauticians.removeWhere((b) => b.id == id);
  }
}
