import 'package:flutter/material.dart';
import '../../data/repositories/beautician_repository.dart';
import '../../domain/models/beautician_model.dart';
import 'audit_provider.dart';

class BeauticiansProvider extends ChangeNotifier {
  final BeauticianRepository _beauticianRepository;
  final AuditProvider? _auditProvider;

  List<BeauticianModel> _beauticians = [];
  bool _isLoading = false;

  BeauticiansProvider({
    BeauticianRepository? beauticianRepository,
    AuditProvider? auditProvider,
  })  : _beauticianRepository = beauticianRepository ?? MockBeauticianRepository(),
        _auditProvider = auditProvider {
    loadBeauticians();
  }

  List<BeauticianModel> get allBeauticians => _beauticians;
  List<BeauticianModel> get activeBeauticians =>
      _beauticians.where((b) => b.isActive).toList();
  bool get isLoading => _isLoading;

  Future<void> loadBeauticians() async {
    _isLoading = true;
    notifyListeners();

    _beauticians = await _beauticianRepository.getBeauticians();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> createBeautician(BeauticianModel beautician, {String actorName = 'Admin'}) async {
    await _beauticianRepository.createBeautician(beautician);
    await _auditProvider?.logAction(
      actorName: actorName,
      actionType: 'CREATE',
      entityType: 'Beautician',
      entityId: beautician.id,
      entityTitle: beautician.name,
      previousValue: null,
      newValue: 'Role: ${beautician.role}, Active: ${beautician.isActive}',
      summary: 'Added new specialist "${beautician.name}".',
    );
    await loadBeauticians();
  }

  Future<void> updateBeautician(
    BeauticianModel updated, {
    String actorName = 'Admin',
    BeauticianModel? previous,
  }) async {
    await _beauticianRepository.updateBeautician(updated);
    await _auditProvider?.logAction(
      actorName: actorName,
      actionType: 'UPDATE',
      entityType: 'Beautician',
      entityId: updated.id,
      entityTitle: updated.name,
      previousValue: previous != null ? 'Role: ${previous.role}, Active: ${previous.isActive}' : null,
      newValue: 'Role: ${updated.role}, Active: ${updated.isActive}',
      summary: 'Updated profile details for "${updated.name}".',
    );
    await loadBeauticians();
  }

  Future<void> deleteBeautician(BeauticianModel beautician, {String actorName = 'Admin'}) async {
    await _beauticianRepository.deleteBeautician(beautician.id);
    await _auditProvider?.logAction(
      actorName: actorName,
      actionType: 'DELETE',
      entityType: 'Beautician',
      entityId: beautician.id,
      entityTitle: beautician.name,
      previousValue: 'Active: ${beautician.isActive}',
      newValue: null,
      summary: 'Removed specialist "${beautician.name}".',
    );
    await loadBeauticians();
  }
}
