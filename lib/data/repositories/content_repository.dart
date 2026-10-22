import '../../domain/models/about_content_model.dart';
import '../../domain/models/branding_settings_model.dart';
import '../../domain/models/contact_info_model.dart';
import '../../domain/models/content_status.dart';
import '../../domain/models/hero_slide_model.dart';
import '../datasources/in_memory_store.dart';

abstract class ContentRepository {
  // Hero Slides
  Future<List<HeroSlideModel>> getHeroSlides({
    ContentStatus? status,
    bool? onlyActive,
  });
  Future<void> saveHeroSlide(HeroSlideModel slide);
  Future<void> deleteHeroSlide(String id);

  // About Content
  Future<AboutContentModel> getAboutContent();
  Future<void> updateAboutContent(AboutContentModel content);

  // Contact Info
  Future<ContactInfoModel> getContactInfo();
  Future<void> updateContactInfo(ContactInfoModel info);

  // Branding Settings
  Future<BrandingSettingsModel> getBrandingSettings();
  Future<void> updateBrandingSettings(BrandingSettingsModel settings);
}

class MockContentRepository implements ContentRepository {
  final InMemoryStore _store;

  MockContentRepository({InMemoryStore? store})
    : _store = store ?? InMemoryStore.instance;

  @override
  Future<List<HeroSlideModel>> getHeroSlides({
    ContentStatus? status,
    bool? onlyActive,
  }) async {
    return _store.heroSlides.where((s) {
      if (status != null && s.status != status) return false;
      if (onlyActive == true && !s.isActive) return false;
      return true;
    }).toList()..sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
  }

  @override
  Future<void> saveHeroSlide(HeroSlideModel slide) async {
    final index = _store.heroSlides.indexWhere((s) => s.id == slide.id);
    if (index != -1) {
      _store.heroSlides[index] = slide;
    } else {
      _store.heroSlides.add(slide);
    }
  }

  @override
  Future<void> deleteHeroSlide(String id) async {
    _store.heroSlides.removeWhere((s) => s.id == id);
  }

  @override
  Future<AboutContentModel> getAboutContent() async => _store.aboutContent;

  @override
  Future<void> updateAboutContent(AboutContentModel content) async {
    _store.aboutContent = content;
  }

  @override
  Future<ContactInfoModel> getContactInfo() async => _store.contactInfo;

  @override
  Future<void> updateContactInfo(ContactInfoModel info) async {
    _store.contactInfo = info;
  }

  @override
  Future<BrandingSettingsModel> getBrandingSettings() async =>
      _store.brandingSettings;

  @override
  Future<void> updateBrandingSettings(BrandingSettingsModel settings) async {
    _store.brandingSettings = settings;
  }
}
