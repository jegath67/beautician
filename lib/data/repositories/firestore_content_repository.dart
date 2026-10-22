import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/about_content_model.dart';
import '../../domain/models/branding_settings_model.dart';
import '../../domain/models/contact_info_model.dart';
import '../../domain/models/content_status.dart';
import '../../domain/models/hero_slide_model.dart';
import 'content_repository.dart';

class FirestoreContentRepository implements ContentRepository {
  final FirebaseFirestore? _customFirestore;
  final String heroCollectionPath;
  final String settingsCollectionPath;

  FirestoreContentRepository({
    FirebaseFirestore? firestore,
    this.heroCollectionPath = 'hero_slides',
    this.settingsCollectionPath = 'site_settings',
  }) : _customFirestore = firestore;

  FirebaseFirestore get _firestore =>
      _customFirestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _heroCollection =>
      _firestore.collection(heroCollectionPath);

  CollectionReference<Map<String, dynamic>> get _settingsCollection =>
      _firestore.collection(settingsCollectionPath);

  // ---------------------------------------------------------
  // Hero Slides
  // ---------------------------------------------------------
  @override
  Future<List<HeroSlideModel>> getHeroSlides({
    ContentStatus? status,
    bool? onlyActive,
  }) async {
    Query<Map<String, dynamic>> query = _heroCollection;

    if (status != null) {
      query = query.where('status', isEqualTo: status.name);
    }
    if (onlyActive == true) {
      query = query.where('isActive', isEqualTo: true);
    }

    final snapshot = await query.get();
    final slides = snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = data['id'] ?? doc.id;
      return HeroSlideModel.fromJson(data);
    }).toList();

    slides.sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
    return slides;
  }

  @override
  Future<void> saveHeroSlide(HeroSlideModel slide) async {
    final docRef = slide.id.isNotEmpty
        ? _heroCollection.doc(slide.id)
        : _heroCollection.doc();
    final data = slide.toJson();
    data['id'] = docRef.id;
    data['updatedAt'] = FieldValue.serverTimestamp();
    await docRef.set(data, SetOptions(merge: true));
  }

  @override
  Future<void> deleteHeroSlide(String id) async {
    await _heroCollection.doc(id).delete();
  }

  // ---------------------------------------------------------
  // About Content (Singleton: site_settings/about)
  // ---------------------------------------------------------
  @override
  Future<AboutContentModel> getAboutContent() async {
    final doc = await _settingsCollection.doc('about').get();
    if (doc.exists && doc.data() != null) {
      return AboutContentModel.fromJson(doc.data()!);
    }
    // Safe default if not yet created in Firestore
    return const AboutContentModel(
      id: 'about',
      title: 'Our Heritage & Philosophy',
      subtitle: 'A sanctuary dedicated to mindful beauty and transformative rituals.',
      story: 'Founded with a passion for excellence, we blend timeless holistic care with modern aesthetic artistry.',
      mission: 'To deliver tailored beauty experiences that inspire confidence and serenity.',
      values: [],
      founderName: 'Ananya Deshmukh',
      founderRole: 'Founder & Master Stylist',
      founderBio: 'Over 15 years crafting transformative bridal and editorial styles.',
      founderImageUrl: 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?auto=format&fit=crop&w=600&q=80',
      credentials: [],
    );
  }

  @override
  Future<void> updateAboutContent(AboutContentModel content) async {
    final data = content.toJson();
    data['updatedAt'] = FieldValue.serverTimestamp();
    await _settingsCollection.doc('about').set(data, SetOptions(merge: true));
  }

  // ---------------------------------------------------------
  // Contact Info & Business Hours (Singleton: site_settings/contact_info)
  // ---------------------------------------------------------
  @override
  Future<ContactInfoModel> getContactInfo() async {
    final doc = await _settingsCollection.doc('contact_info').get();
    if (doc.exists && doc.data() != null) {
      return ContactInfoModel.fromJson(doc.data()!);
    }
    // Safe default
    return const ContactInfoModel(
      phone: '+91 98765 43210',
      email: 'concierge@aurabeauty.com',
      whatsapp: '+91 98765 43210',
      address: '142 Luxury Boulevard, Jubilee Hills',
      cityStateZip: 'Hyderabad, Telangana 500033',
      googleMapsEmbedUrl: '',
      googleMapsDirectionsUrl: '',
      weekDayHours: '09:00 AM – 08:00 PM',
      weekendHours: '10:00 AM – 07:00 PM',
      closedDays: 'Closed on National Holidays',
    );
  }

  @override
  Future<void> updateContactInfo(ContactInfoModel info) async {
    final data = info.toJson();
    data['updatedAt'] = FieldValue.serverTimestamp();
    await _settingsCollection.doc('contact_info').set(data, SetOptions(merge: true));
  }

  // ---------------------------------------------------------
  // Branding Settings (Singleton: site_settings/branding)
  // ---------------------------------------------------------
  @override
  Future<BrandingSettingsModel> getBrandingSettings() async {
    final doc = await _settingsCollection.doc('branding').get();
    if (doc.exists && doc.data() != null) {
      return BrandingSettingsModel.fromJson(doc.data()!);
    }
    // Safe default
    return const BrandingSettingsModel(
      brandName: 'AURA & CO.',
      tagline: 'Luxury Salon & Aesthetic Sanctuary',
      logoUrl: '',
      instagramUrl: '',
      facebookUrl: '',
      youtubeUrl: '',
      pinterestUrl: '',
      currencySymbol: '₹',
      metaDescription: 'Experience premier beauty and aesthetic artistry.',
    );
  }

  @override
  Future<void> updateBrandingSettings(BrandingSettingsModel settings) async {
    final data = settings.toJson();
    data['updatedAt'] = FieldValue.serverTimestamp();
    await _settingsCollection.doc('branding').set(data, SetOptions(merge: true));
  }
}
