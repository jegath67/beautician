import '../../domain/models/content_status.dart';
import '../../domain/models/gallery_item_model.dart';
import '../datasources/in_memory_store.dart';

abstract class GalleryRepository {
  Future<List<GalleryItemModel>> getGalleryItems({
    ContentStatus? status,
    String? category,
    int? limit,
    int? offset,
  });
  Future<GalleryItemModel?> getGalleryItemById(String id);
  Future<void> createGalleryItem(GalleryItemModel item);
  Future<void> updateGalleryItem(GalleryItemModel item);
  Future<void> deleteGalleryItem(String id);
}

class MockGalleryRepository implements GalleryRepository {
  final InMemoryStore _store;

  MockGalleryRepository({InMemoryStore? store})
    : _store = store ?? InMemoryStore.instance;

  @override
  Future<List<GalleryItemModel>> getGalleryItems({
    ContentStatus? status,
    String? category,
    int? limit,
    int? offset,
  }) async {
    var filtered = _store.galleryItems.where((item) {
      if (status != null && item.status != status) return false;
      if (category != null && category.isNotEmpty && category != 'All') {
        if (item.category.toLowerCase() != category.toLowerCase()) return false;
      }
      return true;
    }).toList();

    if (offset != null && offset > 0) {
      if (offset >= filtered.length) return [];
      filtered = filtered.sublist(offset);
    }

    if (limit != null && limit > 0 && limit < filtered.length) {
      filtered = filtered.sublist(0, limit);
    }

    return filtered;
  }

  @override
  Future<GalleryItemModel?> getGalleryItemById(String id) async {
    final index = _store.galleryItems.indexWhere((i) => i.id == id);
    return index != -1 ? _store.galleryItems[index] : null;
  }

  @override
  Future<void> createGalleryItem(GalleryItemModel item) async {
    _store.galleryItems.insert(0, item);
  }

  @override
  Future<void> updateGalleryItem(GalleryItemModel item) async {
    final index = _store.galleryItems.indexWhere((i) => i.id == item.id);
    if (index != -1) {
      _store.galleryItems[index] = item;
    }
  }

  @override
  Future<void> deleteGalleryItem(String id) async {
    _store.galleryItems.removeWhere((i) => i.id == id);
  }
}
