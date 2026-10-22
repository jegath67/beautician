import 'package:flutter/material.dart';
import '../../data/repositories/content_repository.dart';
import '../../domain/models/about_content_model.dart';
import '../../domain/models/branding_settings_model.dart';
import '../../domain/models/contact_info_model.dart';
import '../../domain/models/content_status.dart';
import '../../domain/models/hero_slide_model.dart';
import 'audit_provider.dart';

class ContentProvider extends ChangeNotifier {
  final ContentRepository _contentRepository;
  final AuditProvider? _auditProvider;

  List<HeroSlideModel> _heroSlides = [];
  AboutContentModel? _aboutContent;
  ContactInfoModel? _contactInfo;
  BrandingSettingsModel? _brandingSettings;
  bool _isLoading = false;

  ContentProvider({
    ContentRepository? contentRepository,
    AuditProvider? auditProvider,
  })  : _contentRepository = contentRepository ?? MockContentRepository(),
        _auditProvider = auditProvider {
    loadAllContent();
  }

  List<HeroSlideModel> get allHeroSlides => _heroSlides;
  List<HeroSlideModel> get heroSlides => activePublishedHeroSlides;
  List<HeroSlideModel> get activePublishedHeroSlides => _heroSlides
      .where((s) => s.status == ContentStatus.published && s.isActive)
      .toList();

  AboutContentModel? get aboutContent => _aboutContent;
  ContactInfoModel? get contactInfo => _contactInfo;
  BrandingSettingsModel? get brandingSettings => _brandingSettings;
  bool get isLoading => _isLoading;

  Future<void> loadAllContent() async {
    _isLoading = true;
    notifyListeners();

    _heroSlides = await _contentRepository.getHeroSlides();
    _aboutContent = await _contentRepository.getAboutContent();
    _contactInfo = await _contentRepository.getContactInfo();
    _brandingSettings = await _contentRepository.getBrandingSettings();

    _isLoading = false;
    notifyListeners();
  }

  // Hero Slide Mutations
  Future<void> saveHeroSlide(
    HeroSlideModel slide, {
    String actorName = 'Admin',
    bool isNew = false,
  }) async {
    await _contentRepository.saveHeroSlide(slide);
    await _auditProvider?.logAction(
      actorName: actorName,
      actionType: isNew ? 'CREATE' : 'UPDATE',
      entityType: 'HeroSlide',
      entityId: slide.id,
      entityTitle: slide.title,
      previousValue: null,
      newValue: 'Status: ${slide.status.label}, Order: ${slide.displayOrder}',
      summary: '${isNew ? "Added" : "Updated"} hero banner slide "${slide.title}".',
    );
    await loadAllContent();
  }

  Future<void> deleteHeroSlide(HeroSlideModel slide, {String actorName = 'Admin'}) async {
    await _contentRepository.deleteHeroSlide(slide.id);
    await _auditProvider?.logAction(
      actorName: actorName,
      actionType: 'DELETE',
      entityType: 'HeroSlide',
      entityId: slide.id,
      entityTitle: slide.title,
      previousValue: 'Order: ${slide.displayOrder}',
      newValue: null,
      summary: 'Deleted hero banner slide "${slide.title}".',
    );
    await loadAllContent();
  }

  Future<void> deleteHeroSlideById(String id) async {
    if (_heroSlides.isEmpty) return;
    final slide = _heroSlides.where((s) => s.id == id).firstOrNull;
    if (slide == null) return;
    await deleteHeroSlide(slide);
  }

  // About Content Mutations
  Future<void> updateAboutContent(
    AboutContentModel content, {
    String actorName = 'Admin',
  }) async {
    await _contentRepository.updateAboutContent(content);
    await _auditProvider?.logAction(
      actorName: actorName,
      actionType: 'UPDATE',
      entityType: 'About',
      entityId: content.id,
      entityTitle: 'About Section & Founder Profile',
      previousValue: null,
      newValue: 'Title: ${content.title}',
      summary: 'Updated salon story, mission, and founder biography.',
    );
    await loadAllContent();
  }

  // Contact Info Mutations
  Future<void> updateContactInfo(
    ContactInfoModel info, {
    String actorName = 'Admin',
  }) async {
    await _contentRepository.updateContactInfo(info);
    await _auditProvider?.logAction(
      actorName: actorName,
      actionType: 'UPDATE',
      entityType: 'Contact',
      entityId: 'contact_info',
      entityTitle: 'Contact & Working Hours',
      previousValue: null,
      newValue: 'Phone: ${info.phone}, Hours: ${info.weekDayHours}',
      summary: 'Updated salon contact information and operating hours.',
    );
    await loadAllContent();
  }

  // Branding Settings Mutations
  Future<void> updateBrandingSettings(
    BrandingSettingsModel settings, {
    String actorName = 'Admin',
  }) async {
    await _contentRepository.updateBrandingSettings(settings);
    await _auditProvider?.logAction(
      actorName: actorName,
      actionType: 'UPDATE',
      entityType: 'Settings',
      entityId: 'branding_settings',
      entityTitle: 'Branding & Social Settings',
      previousValue: null,
      newValue: 'Brand: ${settings.brandName}, Tagline: ${settings.tagline}',
      summary: 'Updated brand identity and social media links.',
    );
    await loadAllContent();
  }
}
