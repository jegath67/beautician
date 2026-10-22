import '../../domain/models/content_status.dart';
import '../../domain/models/service_model.dart';
import '../datasources/in_memory_store.dart';

abstract class ServiceRepository {
  Future<List<ServiceModel>> getServices({
    ContentStatus? status,
    String? category,
  });
  Future<ServiceModel?> getServiceById(String id);
  Future<void> createService(ServiceModel service);
  Future<void> updateService(ServiceModel service);
  Future<void> deleteService(String id);
}

class MockServiceRepository implements ServiceRepository {
  final InMemoryStore _store;

  MockServiceRepository({InMemoryStore? store})
    : _store = store ?? InMemoryStore.instance;

  @override
  Future<List<ServiceModel>> getServices({
    ContentStatus? status,
    String? category,
  }) async {
    return _store.services.where((s) {
      if (status != null && s.status != status) return false;
      if (category != null && category.isNotEmpty && category != 'All') {
        if (s.category.toLowerCase() != category.toLowerCase()) return false;
      }
      return true;
    }).toList();
  }

  @override
  Future<ServiceModel?> getServiceById(String id) async {
    final index = _store.services.indexWhere((s) => s.id == id);
    return index != -1 ? _store.services[index] : null;
  }

  @override
  Future<void> createService(ServiceModel service) async {
    _store.services.add(service);
  }

  @override
  Future<void> updateService(ServiceModel service) async {
    final index = _store.services.indexWhere((s) => s.id == service.id);
    if (index != -1) {
      _store.services[index] = service;
    }
  }

  @override
  Future<void> deleteService(String id) async {
    _store.services.removeWhere((s) => s.id == id);
  }
}
