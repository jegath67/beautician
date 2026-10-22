import '../../domain/models/about_content_model.dart';
import '../../domain/models/audit_log_entry_model.dart';
import '../../domain/models/beautician_model.dart';
import '../../domain/models/booking_model.dart';
import '../../domain/models/branding_settings_model.dart';
import '../../domain/models/contact_enquiry_model.dart';
import '../../domain/models/contact_info_model.dart';
import '../../domain/models/content_status.dart';
import '../../domain/models/gallery_item_model.dart';
import '../../domain/models/hero_slide_model.dart';
import '../../domain/models/review_model.dart';
import '../../domain/models/service_model.dart';
import '../../domain/models/user_model.dart';

/// Single source of truth for all in-memory domain state across Admin and Public experiences.
class InMemoryStore {
  // Singleton instance for app-wide lifecycle fallback
  static InMemoryStore? _instance;
  static InMemoryStore get instance => _instance ??= InMemoryStore();

  /// Reset or re-seed the global store (useful for clean test execution)
  static void resetInstance([InMemoryStore? newInstance]) {
    _instance = newInstance;
  }

  // Domain state collections
  final List<ServiceModel> services;
  final List<BeauticianModel> beauticians;
  final List<BookingModel> bookings;
  final List<GalleryItemModel> galleryItems;
  final List<ReviewModel> reviews;
  final List<ContactEnquiryModel> enquiries;
  final List<HeroSlideModel> heroSlides;
  AboutContentModel aboutContent;
  ContactInfoModel contactInfo;
  BrandingSettingsModel brandingSettings;
  final List<AuditLogEntryModel> auditLogs;
  UserModel? currentUser;

  InMemoryStore({
    List<ServiceModel>? initialServices,
    List<BeauticianModel>? initialBeauticians,
    List<BookingModel>? initialBookings,
    List<GalleryItemModel>? initialGalleryItems,
    List<ReviewModel>? initialReviews,
    List<ContactEnquiryModel>? initialEnquiries,
    List<HeroSlideModel>? initialHeroSlides,
    AboutContentModel? initialAboutContent,
    ContactInfoModel? initialContactInfo,
    BrandingSettingsModel? initialBrandingSettings,
    List<AuditLogEntryModel>? initialAuditLogs,
    UserModel? initialCurrentUser,
  }) : services = initialServices ?? _seedServices(),
       beauticians = initialBeauticians ?? _seedBeauticians(),
       bookings = initialBookings ?? _seedBookings(),
       galleryItems = initialGalleryItems ?? _seedGalleryItems(),
       reviews = initialReviews ?? _seedReviews(),
       enquiries = initialEnquiries ?? _seedEnquiries(),
       heroSlides = initialHeroSlides ?? _seedHeroSlides(),
       aboutContent = initialAboutContent ?? _seedAboutContent(),
       contactInfo = initialContactInfo ?? _seedContactInfo(),
       brandingSettings = initialBrandingSettings ?? _seedBrandingSettings(),
       auditLogs = initialAuditLogs ?? _seedAuditLogs(),
       currentUser = initialCurrentUser;

  static List<ServiceModel> _seedServices() => [
    const ServiceModel(
      id: 'srv_1',
      title: 'Royal Bridal Makeover & Styling',
      category: 'Bridal',
      price: 18500,
      durationMinutes: 180,
      description:
          'Comprehensive high-definition bridal artistry including skin prep, custom contouring, luxury hairstyling, saree draping, and setting.',
      imageUrl:
          'https://images.unsplash.com/photo-1519741497674-611481863552?auto=format&fit=crop&w=800&q=80',
      status: ContentStatus.published,
      isFeatured: true,
    ),
    const ServiceModel(
      id: 'srv_2',
      title: 'Hydra-Glow Signature Facial',
      category: 'Skin',
      price: 4500,
      durationMinutes: 75,
      description:
          'Multi-step vortex deep cleansing, ultrasonic pore extraction, botanical serum infusion, and cold cryo-tightening for glass skin.',
      imageUrl:
          'https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?auto=format&fit=crop&w=800&q=80',
      status: ContentStatus.published,
      isFeatured: true,
    ),
    const ServiceModel(
      id: 'srv_3',
      title: 'Couture Balayage & Gloss Finish',
      category: 'Hair',
      price: 8500,
      durationMinutes: 150,
      description:
          'Hand-painted dimensional multidimensional balayage highlights paired with bond repair therapy and high-shine glossing.',
      imageUrl:
          'https://images.unsplash.com/photo-1560066984-138dadb4c035?auto=format&fit=crop&w=800&q=80',
      status: ContentStatus.published,
      isFeatured: true,
    ),
    const ServiceModel(
      id: 'srv_4',
      title: 'Luxe Gel Sculpting & Nail Art',
      category: 'Nails',
      price: 3200,
      durationMinutes: 90,
      description:
          'Custom soft gel extension overlays, cuticle rejuvenation, hand-painted minimalist or chrome accents, and paraffin massage.',
      imageUrl:
          'https://images.unsplash.com/photo-1632345031435-8727f6897d53?auto=format&fit=crop&w=800&q=80',
      status: ContentStatus.published,
      isFeatured: true,
    ),
    const ServiceModel(
      id: 'srv_5',
      title: 'Aromatherapy De-Stress Spa Ritual',
      category: 'Spa',
      price: 5200,
      durationMinutes: 90,
      description:
          'Full body relaxing Swedish pressure therapy utilizing warm organic lavender, sandalwood, and rose oils to release tension.',
      imageUrl:
          'https://images.unsplash.com/photo-1540555700478-4be289fbecef?auto=format&fit=crop&w=800&q=80',
      status: ContentStatus.published,
      isFeatured: false,
    ),
    const ServiceModel(
      id: 'srv_6',
      title: 'Keratin Silk Infusion Treatment',
      category: 'Hair',
      price: 6800,
      durationMinutes: 120,
      description:
          'Formaldehyde-free organic keratin treatment to eliminate frizz, seal the cuticles, and deliver mirror-smooth radiance.',
      imageUrl:
          'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?auto=format&fit=crop&w=800&q=80',
      status: ContentStatus.published,
      isFeatured: false,
    ),
    const ServiceModel(
      id: 'srv_7',
      title: 'Pre-Bridal Radiance Glow Package',
      category: 'Bridal',
      price: 14500,
      durationMinutes: 240,
      description:
          'Complete 3-session luxury pre-wedding skin brightening, full body polish, manicure, pedicure, and hair detox spa.',
      imageUrl:
          'https://images.unsplash.com/photo-1487412720507-e7ab37603c6f?auto=format&fit=crop&w=800&q=80',
      status: ContentStatus.published,
      isFeatured: true,
    ),
    const ServiceModel(
      id: 'srv_8',
      title: 'Editorial HD Glam Makeup',
      category: 'Makeup',
      price: 6500,
      durationMinutes: 90,
      description:
          'Red-carpet ready airbrush HD makeup, dramatic lash extensions, waterproof contouring, and long-wear lip artistry.',
      imageUrl:
          'https://images.unsplash.com/photo-1487412720507-e7ab37603c6f?auto=format&fit=crop&w=800&q=80',
      status: ContentStatus.draft,
      isFeatured: false,
    ),
  ];

  static List<BeauticianModel> _seedBeauticians() => [
    const BeauticianModel(
      id: 'bt_1',
      name: 'Ananya Deshmukh',
      role: 'Creative Art Director & Bridal Specialist',
      bio:
          'Celebrity bridal artist with over 11 years of high-glam experience across Milan, Mumbai, and Chennai fashion weeks.',
      specialties: [
        'Royal Bridal Artistry',
        'Airbrush Makeup',
        'Couture Styling',
      ],
      avatarUrl:
          'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=400&q=80',
      workingDays: [1, 2, 3, 4, 5, 6], // Mon - Sat
      workingHoursStart: '09:00',
      workingHoursEnd: '19:00',
      breakStart: '13:00',
      breakEnd: '14:00',
      rating: 4.95,
      reviewCount: 340,
      isActive: true,
    ),
    const BeauticianModel(
      id: 'bt_2',
      name: 'Pooja Krishnan',
      role: 'Master Aesthetician & Skin Therapist',
      bio:
          'CIDESCO certified clinical skin specialist focused on advanced botanical infusions and holistic dermal transformation.',
      specialties: [
        'HydraFacial Therapy',
        'Bio-Peel Rejuvenation',
        'Detox Rituals',
      ],
      avatarUrl:
          'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?auto=format&fit=crop&w=400&q=80',
      workingDays: [1, 2, 3, 4, 5, 6],
      workingHoursStart: '10:00',
      workingHoursEnd: '18:00',
      breakStart: '13:30',
      breakEnd: '14:30',
      rating: 4.92,
      reviewCount: 215,
      isActive: true,
    ),
    const BeauticianModel(
      id: 'bt_3',
      name: 'Meera Sengupta',
      role: 'Senior Hair Colorist & Balayage Artist',
      bio:
          'Trained at Vidal Sassoon Academy London, passionate about custom tone blending and low-maintenance dimensional color.',
      specialties: [
        'Couture Balayage',
        'Keratin Silk Infusions',
        'Precision Cuts',
      ],
      avatarUrl:
          'https://images.unsplash.com/photo-1580489944761-15a19d654956?auto=format&fit=crop&w=400&q=80',
      workingDays: [2, 3, 4, 5, 6, 7], // Tue - Sun
      workingHoursStart: '10:00',
      workingHoursEnd: '20:00',
      breakStart: '14:00',
      breakEnd: '15:00',
      rating: 4.88,
      reviewCount: 180,
      isActive: true,
    ),
  ];

  static List<BookingModel> _seedBookings() => [
    BookingModel(
      id: 'BK-10821',
      customerName: 'Kavita Menon',
      email: 'kavita.m@example.com',
      phone: '+91 98401 23456',
      serviceId: 'srv_1',
      serviceTitle: 'Royal Bridal Makeover & Styling',
      beauticianId: 'bt_1',
      beauticianName: 'Ananya Deshmukh',
      priceAtBooking: 18500,
      durationMinutes: 180,
      bookingDate: DateTime.now().add(const Duration(days: 1)),
      timeSlot: '10:00 AM',
      status: BookingStatus.confirmed,
      notes: 'South Indian wedding look with custom temple jewelry pairing.',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    BookingModel(
      id: 'BK-10822',
      customerName: 'Sneha Reddy',
      email: 'sneha.r@example.com',
      phone: '+91 98840 56789',
      serviceId: 'srv_2',
      serviceTitle: 'Hydra-Glow Signature Facial',
      beauticianId: 'bt_2',
      beauticianName: 'Pooja Krishnan',
      priceAtBooking: 4500,
      durationMinutes: 75,
      bookingDate: DateTime.now().add(const Duration(days: 2)),
      timeSlot: '02:30 PM',
      status: BookingStatus.pending,
      notes: 'First time facial at Aura. Sensitive skin.',
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
    ),
    BookingModel(
      id: 'BK-10823',
      customerName: 'Radhika Swaminathan',
      email: 'radhika.s@example.com',
      phone: '+91 94440 98765',
      serviceId: 'srv_3',
      serviceTitle: 'Couture Balayage & Gloss Finish',
      beauticianId: 'bt_3',
      beauticianName: 'Meera Sengupta',
      priceAtBooking: 8500,
      durationMinutes: 150,
      bookingDate: DateTime.now().add(const Duration(days: 3)),
      timeSlot: '11:00 AM',
      status: BookingStatus.confirmed,
      notes: 'Caramel highlights on dark brown base.',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    BookingModel(
      id: 'BK-10820',
      customerName: 'Divya Bharathi',
      email: 'divya.b@example.com',
      phone: '+91 97900 11223',
      serviceId: 'srv_4',
      serviceTitle: 'Luxe Gel Sculpting & Nail Art',
      beauticianId: 'bt_1',
      beauticianName: 'Ananya Deshmukh',
      priceAtBooking: 3200,
      durationMinutes: 90,
      bookingDate: DateTime.now().subtract(const Duration(days: 1)),
      timeSlot: '04:00 PM',
      status: BookingStatus.completed,
      notes: 'Chrome finish with nude base.',
      createdAt: DateTime.now().subtract(const Duration(days: 4)),
    ),
  ];

  static List<GalleryItemModel> _seedGalleryItems() => [
    GalleryItemModel(
      id: 'gal_1',
      title: 'Timeless Royal South Indian Bride',
      category: 'Bridal',
      imageUrl:
          'https://images.unsplash.com/photo-1519741497674-611481863552?auto=format&fit=crop&w=800&q=80',
      description:
          'Traditional kanchipuram silk draping with warm antique gold jewelry and floral jada hairstyle.',
      tags: const ['Bridal', 'Traditional', 'Gold', 'Wedding'],
      status: ContentStatus.published,
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
    ),
    GalleryItemModel(
      id: 'gal_2',
      title: 'Dewy Glass Skin Transformation',
      category: 'Skin',
      imageUrl:
          'https://images.unsplash.com/photo-1570172619644-dfd03ed5d881?auto=format&fit=crop&w=800&q=80',
      description:
          'Post Hydra-Glow session displaying radiant, poreless texture and luminous natural reflection.',
      tags: const ['Facial', 'Glow', 'Skincare', 'HydraFacial'],
      status: ContentStatus.published,
      createdAt: DateTime.now().subtract(const Duration(days: 8)),
    ),
    GalleryItemModel(
      id: 'gal_3',
      title: 'Sun-Kissed Toffee Balayage',
      category: 'Hair',
      imageUrl:
          'https://images.unsplash.com/photo-1560066984-138dadb4c035?auto=format&fit=crop&w=800&q=80',
      description:
          'Seamless melt from espresso roots into warm toffee caramel beach waves.',
      tags: const ['Hair', 'Balayage', 'Color', 'Styling'],
      status: ContentStatus.published,
      createdAt: DateTime.now().subtract(const Duration(days: 6)),
    ),
    GalleryItemModel(
      id: 'gal_4',
      title: 'Opal Chrome Minimalist Nails',
      category: 'Nails',
      imageUrl:
          'https://images.unsplash.com/photo-1632345031435-8727f6897d53?auto=format&fit=crop&w=800&q=80',
      description:
          'Almond gel extensions with iridescent glazed donut chrome finish.',
      tags: const ['Nails', 'Chrome', 'Gel', 'Art'],
      status: ContentStatus.published,
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
    GalleryItemModel(
      id: 'gal_5',
      title: 'Reception Glam Smokey Eyes',
      category: 'Makeup',
      imageUrl:
          'https://images.unsplash.com/photo-1487412720507-e7ab37603c6f?auto=format&fit=crop&w=800&q=80',
      description:
          'Velvet matte skin with bronze metallic cut-crease smokey eyes and nude satin lips.',
      tags: const ['Makeup', 'Reception', 'SmokeyEyes', 'Glam'],
      status: ContentStatus.published,
      createdAt: DateTime.now().subtract(const Duration(days: 4)),
    ),
    GalleryItemModel(
      id: 'gal_6',
      title: 'Zen Botanical Spa Suite',
      category: 'Spa',
      imageUrl:
          'https://images.unsplash.com/photo-1540555700478-4be289fbecef?auto=format&fit=crop&w=800&q=80',
      description:
          'Aromatherapy treatment sanctuary illuminated with warm mood lighting and organic botanicals.',
      tags: const ['Spa', 'Wellness', 'Aromatherapy', 'Sanctuary'],
      status: ContentStatus.published,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    GalleryItemModel(
      id: 'gal_7',
      title: 'Boho Textured Bridal Braid',
      category: 'Hair',
      imageUrl:
          'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?auto=format&fit=crop&w=800&q=80',
      description:
          'Voluminous textured fishtail braid interlaced with baby breath and freshwater pearls.',
      tags: const ['Hair', 'Bridal', 'Braid', 'Floral'],
      status: ContentStatus.published,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    GalleryItemModel(
      id: 'gal_8',
      title: 'Contemporary Sangeet Neon Pop',
      category: 'Makeup',
      imageUrl:
          'https://images.unsplash.com/photo-1512496015851-a90fb38ba796?auto=format&fit=crop&w=800&q=80',
      description:
          'Vibrant winged graphic liner paired with glossy coral lips for sangeet celebrations.',
      tags: const ['Sangeet', 'Trendy', 'Makeup', 'Color'],
      status: ContentStatus.draft,
      createdAt: DateTime.now(),
    ),
  ];

  static List<ReviewModel> _seedReviews() => [
    ReviewModel(
      id: 'rev_1',
      clientName: 'Shalini Sundaram',
      rating: 5.0,
      comment:
          'Ananya made me look like an absolute royalty on my wedding day! The makeup stayed immaculate for over 14 hours despite crying and dancing. Everyone was stunned!',
      serviceName: 'Royal Bridal Makeover',
      avatarUrl:
          'https://images.unsplash.com/photo-1544005313-94ddf0286df2?auto=format&fit=crop&w=200&q=80',
      date: DateTime.now().subtract(const Duration(days: 7)),
      status: ContentStatus.published,
      isFeatured: true,
    ),
    ReviewModel(
      id: 'rev_2',
      clientName: 'Dr. Tanya Roy',
      rating: 5.0,
      comment:
          'The Hydra-Glow facial completely restored my dull, exhausted skin. Pooja explained every single botanical ingredient and customized the cold cryo treatment perfectly.',
      serviceName: 'Hydra-Glow Signature Facial',
      avatarUrl:
          'https://images.unsplash.com/photo-1517841905240-472988babdf9?auto=format&fit=crop&w=200&q=80',
      date: DateTime.now().subtract(const Duration(days: 12)),
      status: ContentStatus.published,
      isFeatured: true,
    ),
    ReviewModel(
      id: 'rev_3',
      clientName: 'Aishwarya Raman',
      rating: 5.0,
      comment:
          'Meera is a true color magician. My balayage looks so natural, seamlessly blended, and healthy. The salon ambiance is pure luxury and peaceful comfort.',
      serviceName: 'Couture Balayage & Gloss',
      avatarUrl:
          'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?auto=format&fit=crop&w=200&q=80',
      date: DateTime.now().subtract(const Duration(days: 18)),
      status: ContentStatus.published,
      isFeatured: true,
    ),
    ReviewModel(
      id: 'rev_4',
      clientName: 'Deepa Varma',
      rating: 4.8,
      comment:
          'Best gel nail sculpting experience in the city. The hygiene standards and precision detailing are unmatched. Definitely my go-to luxury salon now.',
      serviceName: 'Luxe Gel Sculpting',
      avatarUrl:
          'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=200&q=80',
      date: DateTime.now().subtract(const Duration(days: 25)),
      status: ContentStatus.published,
      isFeatured: false,
    ),
  ];

  static List<ContactEnquiryModel> _seedEnquiries() => [
    ContactEnquiryModel(
      id: 'enq_1',
      name: 'Pooja Hegde',
      email: 'pooja.h@example.com',
      phone: '+91 99001 22334',
      subject: 'Destination Wedding Makeup Quote for Dec 2026',
      message:
          'Hello! I am planning a 3-day destination wedding in Udaipur with 6 bridesmaids. Wanted to enquire about Ananya’s availability and comprehensive package rates.',
      status: EnquiryStatus.newEnquiry,
      createdAt: DateTime.now().subtract(const Duration(hours: 3)),
    ),
    ContactEnquiryModel(
      id: 'enq_2',
      name: 'Nandini Swamy',
      email: 'nandini.s@example.com',
      phone: '+91 98200 44556',
      subject: 'Corporate Spa Day Booking',
      message:
          'Looking to book exclusive salon access for a team of 8 on a Friday afternoon for facial and massage therapies.',
      status: EnquiryStatus.read,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  static List<HeroSlideModel> _seedHeroSlides() => [
    const HeroSlideModel(
      id: 'hero_1',
      title: 'Elegance & Artistry Redefined',
      subtitle:
          'Indulge in bespoke bridal makeovers, rejuvenating botanical skincare, and luxury hair aesthetics crafted by celebrated stylists.',
      primaryCtaText: 'Book Appointment',
      primaryCtaUrl: '/booking',
      secondaryCtaText: 'Explore Services',
      secondaryCtaUrl: '/services',
      imageUrl:
          'https://images.unsplash.com/photo-1560066984-138dadb4c035?auto=format&fit=crop&w=1920&q=80',
      displayOrder: 1,
      status: ContentStatus.published,
      isActive: true,
    ),
    const HeroSlideModel(
      id: 'hero_2',
      title: 'Timeless Royal Bridal Elegance',
      subtitle:
          'Experience customized bridal couture glam that elevates your natural radiance for your most momentous celebration.',
      primaryCtaText: 'Bridal Packages',
      primaryCtaUrl: '/services',
      secondaryCtaText: 'View Gallery',
      secondaryCtaUrl: '/gallery',
      imageUrl:
          'https://images.unsplash.com/photo-1519741497674-611481863552?auto=format&fit=crop&w=1920&q=80',
      displayOrder: 2,
      status: ContentStatus.published,
      isActive: true,
    ),
    const HeroSlideModel(
      id: 'hero_3',
      title: 'Botanical Sanctuary & Zen Wellness',
      subtitle:
          'Immerse your senses in therapeutic organic facial infusions, deep tissue relaxation, and restorative wellness rituals.',
      primaryCtaText: 'Explore Spa Rituals',
      primaryCtaUrl: '/services',
      secondaryCtaText: 'Contact Us',
      secondaryCtaUrl: '/contact',
      imageUrl:
          'https://images.unsplash.com/photo-1540555700478-4be289fbecef?auto=format&fit=crop&w=1920&q=80',
      displayOrder: 3,
      status: ContentStatus.published,
      isActive: true,
    ),
  ];

  static AboutContentModel _seedAboutContent() => const AboutContentModel(
    id: 'abt_1',
    title: 'The Sanctuary of Grace & Modern Aesthetics',
    subtitle:
        'Where artisanal craftsmanship meets clinical excellence in holistic beauty.',
    story:
        'Founded in 2018, AURA & CO. was born from a singular passion: to create an unhurried sanctuary where modern aesthetic science merges with the timeless artistry of luxury beauty. Our private studio suites offer an exclusive escape tailored for discerning clients seeking transformative bridal styling, luminous skin therapy, and dimensional hair artistry.',
    mission:
        'To empower every client with radiant confidence through bespoke, skin-safe treatments, world-class organic formulations, and masters of aesthetic precision.',
    values: [
      'Artisanal Precision & Tailored Beauty',
      'Uncompromising Hygiene & Medical-Grade Sterilization',
      'Cruelty-Free, Certified Organic Formulations',
      'Holistic Wellness & Relaxing Experience',
    ],
    founderName: 'Ananya Deshmukh',
    founderRole: 'Founder & Creative Art Director',
    founderBio:
        'Celebrity bridal artist trained across London and Milan, Ananya has styled over 800+ brides and featured in Vogue India, Elle, and Harper\'s Bazaar.',
    founderImageUrl:
        'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=600&q=80',
    credentials: [
      'CIDESCO Switzerland Certified Aesthetician',
      'Vidal Sassoon London Master Colorist',
      '12+ Years Industry Experience',
      'Over 4,500+ Satisfied Luxury Clients',
    ],
    status: ContentStatus.published,
  );

  static ContactInfoModel _seedContactInfo() => const ContactInfoModel(
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

  static BrandingSettingsModel
  _seedBrandingSettings() => const BrandingSettingsModel(
    brandName: 'AURA & CO.',
    tagline: 'Luxury Salon & Wellness Spa',
    logoUrl: '',
    instagramUrl: 'https://instagram.com',
    facebookUrl: 'https://facebook.com',
    youtubeUrl: 'https://youtube.com',
    pinterestUrl: 'https://pinterest.com',
    metaDescription:
        'Aura & Co. - Chennai\'s premier luxury beauty lounge offering bridal artistry, hydra-facials, balayage hair color, and bespoke nail aesthetics.',
    currencySymbol: '₹',
  );

  static List<AuditLogEntryModel> _seedAuditLogs() => [
    AuditLogEntryModel(
      id: 'log_1',
      actorName: 'Priya Sharma (Manager)',
      actionType: 'PUBLISH',
      entityType: 'Service',
      entityId: 'srv_1',
      entityTitle: 'Royal Bridal Makeover & Styling',
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      previousValue: 'Status: Draft, Price: ₹18000',
      newValue: 'Status: Published, Price: ₹18500',
      summary:
          'Updated bridal package pricing and published to public catalog.',
    ),
    AuditLogEntryModel(
      id: 'log_2',
      actorName: 'Priya Sharma (Manager)',
      actionType: 'STATUS_CHANGE',
      entityType: 'Booking',
      entityId: 'BK-10821',
      entityTitle: 'Kavita Menon - Bridal Booking',
      timestamp: DateTime.now().subtract(const Duration(hours: 3)),
      previousValue: 'Status: Pending',
      newValue: 'Status: Confirmed',
      summary:
          'Confirmed bridal makeover appointment after customer deposit call.',
    ),
    AuditLogEntryModel(
      id: 'log_3',
      actorName: 'System Engine',
      actionType: 'CREATE',
      entityType: 'Booking',
      entityId: 'BK-10822',
      entityTitle: 'Sneha Reddy - Hydra-Glow Facial',
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
      previousValue: null,
      newValue: 'Status: Pending, Slot: 02:30 PM',
      summary: 'Customer submitted new online appointment booking.',
    ),
  ];
}
