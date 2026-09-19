import '../../domain/models/about_content_model.dart';
import '../../domain/models/branding_settings_model.dart';
import '../../domain/models/contact_info_model.dart';
import '../../domain/models/content_status.dart';
import '../../domain/models/hero_slide_model.dart';

abstract class ContentRepository {
  // Hero Slides
  Future<List<HeroSlideModel>> getHeroSlides({ContentStatus? status, bool? onlyActive});
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
  final List<HeroSlideModel> _heroSlides = [
    const HeroSlideModel(
      id: 'hero_1',
      title: 'Elegance & Artistry Redefined',
      subtitle: 'Indulge in bespoke bridal makeovers, rejuvenating botanical skincare, and luxury hair aesthetics crafted by celebrated stylists.',
      primaryCtaText: 'Book Appointment',
      primaryCtaUrl: '/booking',
      secondaryCtaText: 'Explore Services',
      secondaryCtaUrl: '/services',
      imageUrl: 'https://images.unsplash.com/photo-1560066984-138dadb4c035?auto=format&fit=crop&w=1920&q=80',
      displayOrder: 1,
      status: ContentStatus.published,
      isActive: true,
    ),
    const HeroSlideModel(
      id: 'hero_2',
      title: 'Timeless Royal Bridal Elegance',
      subtitle: 'Experience customized bridal couture glam that elevates your natural radiance for your most momentous celebration.',
      primaryCtaText: 'Bridal Packages',
      primaryCtaUrl: '/services',
      secondaryCtaText: 'View Gallery',
      secondaryCtaUrl: '/gallery',
      imageUrl: 'https://images.unsplash.com/photo-1519741497674-611481863552?auto=format&fit=crop&w=1920&q=80',
      displayOrder: 2,
      status: ContentStatus.published,
      isActive: true,
    ),
    const HeroSlideModel(
      id: 'hero_3',
      title: 'Botanical Sanctuary & Zen Wellness',
      subtitle: 'Immerse your senses in therapeutic organic facial infusions, deep tissue relaxation, and restorative wellness rituals.',
      primaryCtaText: 'Explore Spa Rituals',
      primaryCtaUrl: '/services',
      secondaryCtaText: 'Contact Us',
      secondaryCtaUrl: '/contact',
      imageUrl: 'https://images.unsplash.com/photo-1540555700478-4be289fbecef?auto=format&fit=crop&w=1920&q=80',
      displayOrder: 3,
      status: ContentStatus.published,
      isActive: true,
    ),
  ];

  AboutContentModel _aboutContent = const AboutContentModel(
    id: 'abt_1',
    title: 'The Sanctuary of Grace & Modern Aesthetics',
    subtitle: 'Where artisanal craftsmanship meets clinical excellence in holistic beauty.',
    story: 'Founded in 2018, AURA & CO. was born from a singular passion: to create an unhurried sanctuary where modern aesthetic science merges with the timeless artistry of luxury beauty. Our private studio suites offer an exclusive escape tailored for discerning clients seeking transformative bridal styling, luminous skin therapy, and dimensional hair artistry.',
    mission: 'To empower every client with radiant confidence through bespoke, skin-safe treatments, world-class organic formulations, and masters of aesthetic precision.',
    values: [
      'Artisanal Precision & Tailored Beauty',
      'Uncompromising Hygiene & Medical-Grade Sterilization',
      'Cruelty-Free, Certified Organic Formulations',
      'Holistic Wellness & Relaxing Experience',
    ],
    founderName: 'Ananya Deshmukh',
    founderRole: 'Founder & Creative Art Director',
    founderBio: 'Celebrity bridal artist trained across London and Milan, Ananya has styled over 800+ brides and featured in Vogue India, Elle, and Harper\'s Bazaar.',
    founderImageUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=600&q=80',
    credentials: [
      'CIDESCO Switzerland Certified Aesthetician',
      'Vidal Sassoon London Master Colorist',
      '12+ Years Industry Experience',
      'Over 4,500+ Satisfied Luxury Clients',
    ],
    status: ContentStatus.published,
  );

  ContactInfoModel _contactInfo = const ContactInfoModel(
    phone: '+91 98400 77889',
    email: 'concierge@aurabeauty.com',
    whatsapp: '+91 98400 77889',
    address: '42/8, Khader Nawaz Khan Road, Nungambakkam',
    cityStateZip: 'Chennai, Tamil Nadu 600006',
    googleMapsEmbedUrl: 'https://maps.google.com',
    googleMapsDirectionsUrl: 'https://maps.google.com',
    weekDayHours: '09:00 AM – 08:00 PM',
    weekendHours: '09:30 AM – 07:00 PM',
    closedDays: 'Open all 7 days by appointment',
  );

  BrandingSettingsModel _brandingSettings = const BrandingSettingsModel(
    brandName: 'AURA & CO.',
    tagline: 'Luxury Salon & Wellness Spa',
    logoUrl: '',
    instagramUrl: 'https://instagram.com',
    facebookUrl: 'https://facebook.com',
    youtubeUrl: 'https://youtube.com',
    pinterestUrl: 'https://pinterest.com',
    metaDescription: 'Aura & Co. - Chennai\'s premier luxury beauty lounge offering bridal artistry, hydra-facials, balayage hair color, and bespoke nail aesthetics.',
    currencySymbol: '₹',
  );

  @override
  Future<List<HeroSlideModel>> getHeroSlides({ContentStatus? status, bool? onlyActive}) async {
    return _heroSlides.where((s) {
      if (status != null && s.status != status) return false;
      if (onlyActive == true && !s.isActive) return false;
      return true;
    }).toList()
      ..sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
  }

  @override
  Future<void> saveHeroSlide(HeroSlideModel slide) async {
    final index = _heroSlides.indexWhere((s) => s.id == slide.id);
    if (index != -1) {
      _heroSlides[index] = slide;
    } else {
      _heroSlides.add(slide);
    }
  }

  @override
  Future<void> deleteHeroSlide(String id) async {
    _heroSlides.removeWhere((s) => s.id == id);
  }

  @override
  Future<AboutContentModel> getAboutContent() async => _aboutContent;

  @override
  Future<void> updateAboutContent(AboutContentModel content) async {
    _aboutContent = content;
  }

  @override
  Future<ContactInfoModel> getContactInfo() async => _contactInfo;

  @override
  Future<void> updateContactInfo(ContactInfoModel info) async {
    _contactInfo = info;
  }

  @override
  Future<BrandingSettingsModel> getBrandingSettings() async => _brandingSettings;

  @override
  Future<void> updateBrandingSettings(BrandingSettingsModel settings) async {
    _brandingSettings = settings;
  }
}
