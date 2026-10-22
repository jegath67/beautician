import 'package:flutter/material.dart';
import '../../data/repositories/gallery_repository.dart';
import '../../domain/models/content_status.dart';
import '../../domain/models/gallery_item_model.dart';
import 'audit_provider.dart';

class GalleryProvider extends ChangeNotifier {
  final GalleryRepository _galleryRepository;
  final AuditProvider? _auditProvider;

  List<GalleryItemModel> _items = [];
  String _selectedCategory = 'All';
  final int _pageSize = 6;
  int _currentPage = 1;
  bool _isLoading = false;

  GalleryProvider({
    GalleryRepository? galleryRepository,
    AuditProvider? auditProvider,
  })  : _galleryRepository = galleryRepository ?? MockGalleryRepository(),
        _auditProvider = auditProvider {
    loadGallery();
  }

  List<GalleryItemModel> get allItems => _items;
  List<GalleryItemModel> get activeItems => publishedItems;

  List<GalleryItemModel> get publishedItems {
    var list = _items.where((i) => i.status == ContentStatus.published).toList();
    if (_selectedCategory != 'All') {
      list = list
          .where((i) => i.category.toLowerCase() == _selectedCategory.toLowerCase())
          .toList();
    }
    return list;
  }

  /// Paginated slice for public UI to avoid loading huge asset sets at once
  List<GalleryItemModel> get paginatedPublishedItems {
    final list = publishedItems;
    final totalToShow = _currentPage * _pageSize;
    if (totalToShow >= list.length) return list;
    return list.sublist(0, totalToShow);
  }

  bool get hasMoreToLoad =>
      paginatedPublishedItems.length < publishedItems.length;

  List<String> get categories {
    final set = <String>{'All'};
    for (final i in _items) {
      set.add(i.category);
    }
    return set.toList();
  }

  String get selectedCategory => _selectedCategory;
  bool get isLoading => _isLoading;

  Future<void> loadGallery() async {
    _isLoading = true;
    notifyListeners();

    _items = await _galleryRepository.getGalleryItems();
    _isLoading = false;
    notifyListeners();
  }

  void selectCategory(String category) {
    _selectedCategory = category;
    _currentPage = 1; // Reset pagination on category switch
    notifyListeners();
  }

  void loadMore() {
    if (hasMoreToLoad) {
      _currentPage++;
      notifyListeners();
    }
  }

  Future<void> createGalleryItem(
    GalleryItemModel item, {
    String actorName = 'Admin',
  }) async {
    await _galleryRepository.createGalleryItem(item);
    await _auditProvider?.logAction(
      actorName: actorName,
      actionType: 'CREATE',
      entityType: 'Gallery',
      entityId: item.id,
      entityTitle: item.title,
      previousValue: null,
      newValue: 'Category: ${item.category}, Status: ${item.status.label}',
      summary: 'Uploaded new transformation photo "${item.title}".',
    );
    await loadGallery();
  }

  Future<void> updateGalleryItem(
    GalleryItemModel updated, {
    String actorName = 'Admin',
    GalleryItemModel? previous,
  }) async {
    await _galleryRepository.updateGalleryItem(updated);
    await _auditProvider?.logAction(
      actorName: actorName,
      actionType: 'UPDATE',
      entityType: 'Gallery',
      entityId: updated.id,
      entityTitle: updated.title,
      previousValue: previous != null ? 'Status: ${previous.status.label}' : null,
      newValue: 'Status: ${updated.status.label}',
      summary: 'Updated gallery item "${updated.title}".',
    );
    await loadGallery();
  }

  Future<void> togglePublishStatus(
    GalleryItemModel item,
    ContentStatus newStatus, {
    String actorName = 'Admin',
  }) async {
    final updated = item.copyWith(status: newStatus);
    await _galleryRepository.updateGalleryItem(updated);
    await _auditProvider?.logAction(
      actorName: actorName,
      actionType: newStatus == ContentStatus.published ? 'PUBLISH' : 'STATUS_CHANGE',
      entityType: 'Gallery',
      entityId: item.id,
      entityTitle: item.title,
      previousValue: 'Status: ${item.status.label}',
      newValue: 'Status: ${newStatus.label}',
      summary: 'Changed status of gallery photo "${item.title}" to ${newStatus.label}.',
    );
    await loadGallery();
  }

  Future<void> deleteGalleryItem(
    GalleryItemModel item, {
    String actorName = 'Admin',
  }) async {
    await _galleryRepository.deleteGalleryItem(item.id);
    await _auditProvider?.logAction(
      actorName: actorName,
      actionType: 'DELETE',
      entityType: 'Gallery',
      entityId: item.id,
      entityTitle: item.title,
      previousValue: 'Status: ${item.status.label}',
      newValue: null,
      summary: 'Deleted photo "${item.title}".',
    );
    await loadGallery();
  }

  Future<void> addItem(GalleryItemModel item) => createGalleryItem(item);
  Future<void> updateItem(GalleryItemModel item) => updateGalleryItem(item);

  Future<void> togglePublishStatusById(String id) async {
    if (_items.isEmpty) return;
    final item = _items.where((i) => i.id == id).firstOrNull;
    if (item == null) return;
    final newStatus = item.status == ContentStatus.published
        ? ContentStatus.draft
        : ContentStatus.published;
    await togglePublishStatus(item, newStatus);
  }

  Future<void> deleteItem(String id) async {
    if (_items.isEmpty) return;
    final item = _items.where((i) => i.id == id).firstOrNull;
    if (item == null) return;
    await deleteGalleryItem(item);
  }
}
