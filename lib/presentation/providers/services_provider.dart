import 'package:flutter/material.dart';
import '../../data/repositories/service_repository.dart';
import '../../domain/models/content_status.dart';
import '../../domain/models/service_model.dart';
import 'audit_provider.dart';

class ServicesProvider extends ChangeNotifier {
  final ServiceRepository _serviceRepository;
  final AuditProvider? _auditProvider;

  List<ServiceModel> _services = [];
  String _selectedCategory = 'All';
  bool _isLoading = false;

  ServicesProvider({
    ServiceRepository? serviceRepository,
    AuditProvider? auditProvider,
  })  : _serviceRepository = serviceRepository ?? MockServiceRepository(),
        _auditProvider = auditProvider {
    loadServices();
  }

  List<ServiceModel> get allServices => _services;
  List<ServiceModel> get services => publishedServices;
  List<ServiceModel> get publishedServices =>
      _services.where((s) => s.status == ContentStatus.published).toList();
  List<ServiceModel> get featuredServices =>
      publishedServices.where((s) => s.isFeatured).toList();

  List<ServiceModel> get filteredPublishedServices {
    if (_selectedCategory == 'All') return publishedServices;
    return publishedServices
        .where((s) => s.category.toLowerCase() == _selectedCategory.toLowerCase())
        .toList();
  }

  List<String> get categories {
    final set = <String>{'All'};
    for (final s in _services) {
      set.add(s.category);
    }
    return set.toList();
  }

  String get selectedCategory => _selectedCategory;
  bool get isLoading => _isLoading;

  Future<void> loadServices() async {
    _isLoading = true;
    notifyListeners();

    _services = await _serviceRepository.getServices();
    _isLoading = false;
    notifyListeners();
  }

  void selectCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  Future<void> createService(ServiceModel service, {String actorName = 'Admin'}) async {
    await _serviceRepository.createService(service);
    await _auditProvider?.logAction(
      actorName: actorName,
      actionType: 'CREATE',
      entityType: 'Service',
      entityId: service.id,
      entityTitle: service.title,
      previousValue: null,
      newValue: 'Status: ${service.status.label}, Price: ₹${service.price}',
      summary: 'Created new service "${service.title}" under ${service.category}.',
    );
    await loadServices();
  }

  Future<void> updateService(
    ServiceModel updatedService, {
    String actorName = 'Admin',
    ServiceModel? previousService,
  }) async {
    await _serviceRepository.updateService(updatedService);
    await _auditProvider?.logAction(
      actorName: actorName,
      actionType: 'UPDATE',
      entityType: 'Service',
      entityId: updatedService.id,
      entityTitle: updatedService.title,
      previousValue: previousService != null
          ? 'Price: ₹${previousService.price}, Status: ${previousService.status.label}'
          : null,
      newValue: 'Price: ₹${updatedService.price}, Status: ${updatedService.status.label}',
      summary: 'Updated service details for "${updatedService.title}".',
    );
    await loadServices();
  }

  Future<void> togglePublishStatus(
    ServiceModel service,
    ContentStatus newStatus, {
    String actorName = 'Admin',
  }) async {
    final updated = service.copyWith(status: newStatus);
    await _serviceRepository.updateService(updated);
    await _auditProvider?.logAction(
      actorName: actorName,
      actionType: newStatus == ContentStatus.published ? 'PUBLISH' : 'STATUS_CHANGE',
      entityType: 'Service',
      entityId: service.id,
      entityTitle: service.title,
      previousValue: 'Status: ${service.status.label}',
      newValue: 'Status: ${newStatus.label}',
      summary: 'Changed status of "${service.title}" to ${newStatus.label}.',
    );
    await loadServices();
  }

  Future<void> deleteService(ServiceModel service, {String actorName = 'Admin'}) async {
    await _serviceRepository.deleteService(service.id);
    await _auditProvider?.logAction(
      actorName: actorName,
      actionType: 'DELETE',
      entityType: 'Service',
      entityId: service.id,
      entityTitle: service.title,
      previousValue: 'Status: ${service.status.label}, Price: ₹${service.price}',
      newValue: null,
      summary: 'Deleted service "${service.title}".',
    );
    await loadServices();
  }

  Future<void> togglePublishStatusById(String id) async {
    final service = _services.firstWhere((s) => s.id == id, orElse: () => _services.first);
    final newStatus = service.status == ContentStatus.published
        ? ContentStatus.draft
        : ContentStatus.published;
    await togglePublishStatus(service, newStatus);
  }

  Future<void> deleteServiceById(String id) async {
    final service = _services.firstWhere((s) => s.id == id, orElse: () => _services.first);
    await deleteService(service);
  }
}
