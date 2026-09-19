import '../../domain/models/content_status.dart';
import '../../domain/models/gallery_item_model.dart';

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
  final List<GalleryItemModel> _items = [
    GalleryItemModel(
      id: 'gal_1',
      title: 'Timeless Royal South Indian Bride',
      category: 'Bridal',
      imageUrl: 'https://images.unsplash.com/photo-1519741497674-611481863552?auto=format&fit=crop&w=800&q=80',
      description: 'Traditional kanchipuram silk draping with warm antique gold jewelry and floral jada hairstyle.',
      tags: ['Bridal', 'Traditional', 'Gold', 'Wedding'],
      status: ContentStatus.published,
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
    ),
    GalleryItemModel(
      id: 'gal_2',
      title: 'Dewy Glass Skin Transformation',
      category: 'Skin',
      imageUrl: 'https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?auto=format&fit=crop&w=800&q=80',
      description: 'Post Hydra-Glow session displaying radiant, poreless texture and luminous natural reflection.',
      tags: ['Facial', 'Glow', 'Skincare', 'HydraFacial'],
      status: ContentStatus.published,
      createdAt: DateTime.now().subtract(const Duration(days: 8)),
    ),
    GalleryItemModel(
      id: 'gal_3',
      title: 'Sun-Kissed Toffee Balayage',
      category: 'Hair',
      imageUrl: 'https://images.unsplash.com/photo-1560066984-138dadb4c035?auto=format&fit=crop&w=800&q=80',
      description: 'Seamless melt from espresso roots into warm toffee caramel beach waves.',
      tags: ['Hair', 'Balayage', 'Color', 'Styling'],
      status: ContentStatus.published,
      createdAt: DateTime.now().subtract(const Duration(days: 6)),
    ),
    GalleryItemModel(
      id: 'gal_4',
      title: 'Opal Chrome Minimalist Nails',
      category: 'Nails',
      imageUrl: 'https://images.unsplash.com/photo-1632345031435-8727f6897d53?auto=format&fit=crop&w=800&q=80',
      description: 'Almond gel extensions with iridescent glazed donut chrome finish.',
      tags: ['Nails', 'Chrome', 'Gel', 'Art'],
      status: ContentStatus.published,
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
    GalleryItemModel(
      id: 'gal_5',
      title: 'Reception Glam Smokey Eyes',
      category: 'Makeup',
      imageUrl: 'https://images.unsplash.com/photo-1487412720507-e7ab37603c6f?auto=format&fit=crop&w=800&q=80',
      description: 'Velvet matte skin with bronze metallic cut-crease smokey eyes and nude satin lips.',
      tags: ['Makeup', 'Reception', 'SmokeyEyes', 'Glam'],
      status: ContentStatus.published,
      createdAt: DateTime.now().subtract(const Duration(days: 4)),
    ),
    GalleryItemModel(
      id: 'gal_6',
      title: 'Zen Botanical Spa Suite',
      category: 'Spa',
      imageUrl: 'https://images.unsplash.com/photo-1540555700478-4be289fbecef?auto=format&fit=crop&w=800&q=80',
      description: 'Aromatherapy treatment sanctuary illuminated with warm mood lighting and organic botanicals.',
      tags: ['Spa', 'Wellness', 'Aromatherapy', 'Sanctuary'],
      status: ContentStatus.published,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    GalleryItemModel(
      id: 'gal_7',
      title: 'Boho Textured Bridal Braid',
      category: 'Hair',
      imageUrl: 'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?auto=format&fit=crop&w=800&q=80',
      description: 'Voluminous textured fishtail braid interlaced with baby breath and freshwater pearls.',
      tags: ['Hair', 'Bridal', 'Braid', 'Floral'],
      status: ContentStatus.published,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    GalleryItemModel(
      id: 'gal_8',
      title: 'Contemporary Sangeet Neon Pop',
      category: 'Makeup',
      imageUrl: 'https://images.unsplash.com/photo-1512496015851-a90fb38ba796?auto=format&fit=crop&w=800&q=80',
      description: 'Vibrant winged graphic liner paired with glossy coral lips for sangeet celebrations.',
      tags: ['Sangeet', 'Trendy', 'Makeup', 'Color'],
      status: ContentStatus.draft,
      createdAt: DateTime.now(),
    ),
  ];

  @override
  Future<List<GalleryItemModel>> getGalleryItems({
    ContentStatus? status,
    String? category,
    int? limit,
    int? offset,
  }) async {
    var filtered = _items.where((item) {
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
    final index = _items.indexWhere((i) => i.id == id);
    return index != -1 ? _items[index] : null;
  }

  @override
  Future<void> createGalleryItem(GalleryItemModel item) async {
    _items.insert(0, item);
  }

  @override
  Future<void> updateGalleryItem(GalleryItemModel item) async {
    final index = _items.indexWhere((i) => i.id == item.id);
    if (index != -1) {
      _items[index] = item;
    }
  }

  @override
  Future<void> deleteGalleryItem(String id) async {
    _items.removeWhere((i) => i.id == id);
  }
}
