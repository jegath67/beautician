import '../../domain/models/content_status.dart';
import '../../domain/models/service_model.dart';

abstract class ServiceRepository {
  Future<List<ServiceModel>> getServices({ContentStatus? status, String? category});
  Future<ServiceModel?> getServiceById(String id);
  Future<void> createService(ServiceModel service);
  Future<void> updateService(ServiceModel service);
  Future<void> deleteService(String id);
}

class MockServiceRepository implements ServiceRepository {
  final List<ServiceModel> _services = [
    const ServiceModel(
      id: 'srv_1',
      title: 'Royal Bridal Makeover & Styling',
      category: 'Bridal',
      price: 18500,
      durationMinutes: 180,
      description: 'Comprehensive high-definition bridal artistry including skin prep, custom contouring, luxury hairstyling, saree draping, and setting.',
      imageUrl: 'https://images.unsplash.com/photo-1519741497674-611481863552?auto=format&fit=crop&w=800&q=80',
      status: ContentStatus.published,
      isFeatured: true,
    ),
    const ServiceModel(
      id: 'srv_2',
      title: 'Hydra-Glow Signature Facial',
      category: 'Skin',
      price: 4500,
      durationMinutes: 75,
      description: 'Multi-step vortex deep cleansing, ultrasonic pore extraction, botanical serum infusion, and cold cryo-tightening for glass skin.',
      imageUrl: 'https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?auto=format&fit=crop&w=800&q=80',
      status: ContentStatus.published,
      isFeatured: true,
    ),
    const ServiceModel(
      id: 'srv_3',
      title: 'Couture Balayage & Gloss Finish',
      category: 'Hair',
      price: 8500,
      durationMinutes: 150,
      description: 'Hand-painted dimensional multidimensional balayage highlights paired with bond repair therapy and high-shine glossing.',
      imageUrl: 'https://images.unsplash.com/photo-1560066984-138dadb4c035?auto=format&fit=crop&w=800&q=80',
      status: ContentStatus.published,
      isFeatured: true,
    ),
    const ServiceModel(
      id: 'srv_4',
      title: 'Luxe Gel Sculpting & Nail Art',
      category: 'Nails',
      price: 3200,
      durationMinutes: 90,
      description: 'Custom soft gel extension overlays, cuticle rejuvenation, hand-painted minimalist or chrome accents, and paraffin massage.',
      imageUrl: 'https://images.unsplash.com/photo-1632345031435-8727f6897d53?auto=format&fit=crop&w=800&q=80',
      status: ContentStatus.published,
      isFeatured: true,
    ),
    const ServiceModel(
      id: 'srv_5',
      title: 'Aromatherapy De-Stress Spa Ritual',
      category: 'Spa',
      price: 5200,
      durationMinutes: 90,
      description: 'Full body relaxing Swedish pressure therapy utilizing warm organic lavender, sandalwood, and rose oils to release tension.',
      imageUrl: 'https://images.unsplash.com/photo-1540555700478-4be289fbecef?auto=format&fit=crop&w=800&q=80',
      status: ContentStatus.published,
      isFeatured: false,
    ),
    const ServiceModel(
      id: 'srv_6',
      title: 'Keratin Silk Infusion Treatment',
      category: 'Hair',
      price: 6800,
      durationMinutes: 120,
      description: 'Formaldehyde-free organic keratin treatment to eliminate frizz, seal the cuticles, and deliver mirror-smooth radiance.',
      imageUrl: 'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?auto=format&fit=crop&w=800&q=80',
      status: ContentStatus.published,
      isFeatured: false,
    ),
    const ServiceModel(
      id: 'srv_7',
      title: 'Pre-Bridal Radiance Glow Package',
      category: 'Bridal',
      price: 14500,
      durationMinutes: 240,
      description: 'Complete 3-session luxury pre-wedding skin brightening, full body polish, manicure, pedicure, and hair detox spa.',
      imageUrl: 'https://images.unsplash.com/photo-1487412720507-e7ab37603c6f?auto=format&fit=crop&w=800&q=80',
      status: ContentStatus.published,
      isFeatured: true,
    ),
    const ServiceModel(
      id: 'srv_8',
      title: 'Editorial HD Glam Makeup',
      category: 'Makeup',
      price: 6500,
      durationMinutes: 90,
      description: 'Red-carpet ready airbrush HD makeup, dramatic lash extensions, waterproof contouring, and long-wear lip artistry.',
      imageUrl: 'https://images.unsplash.com/photo-1487412720507-e7ab37603c6f?auto=format&fit=crop&w=800&q=80',
      status: ContentStatus.draft,
      isFeatured: false,
    ),
  ];

  @override
  Future<List<ServiceModel>> getServices({ContentStatus? status, String? category}) async {
    return _services.where((s) {
      if (status != null && s.status != status) return false;
      if (category != null && category.isNotEmpty && category != 'All') {
        if (s.category.toLowerCase() != category.toLowerCase()) return false;
      }
      return true;
    }).toList();
  }

  @override
  Future<ServiceModel?> getServiceById(String id) async {
    final index = _services.indexWhere((s) => s.id == id);
    return index != -1 ? _services[index] : null;
  }

  @override
  Future<void> createService(ServiceModel service) async {
    _services.add(service);
  }

  @override
  Future<void> updateService(ServiceModel service) async {
    final index = _services.indexWhere((s) => s.id == service.id);
    if (index != -1) {
      _services[index] = service;
    }
  }

  @override
  Future<void> deleteService(String id) async {
    _services.removeWhere((s) => s.id == id);
  }
}
