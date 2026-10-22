import 'package:flutter_test/flutter_test.dart';
import 'package:beautician/data/datasources/in_memory_store.dart';
import 'package:beautician/data/repositories/beautician_repository.dart';
import 'package:beautician/data/repositories/booking_repository.dart';
import 'package:beautician/data/repositories/content_repository.dart';
import 'package:beautician/data/repositories/enquiry_repository.dart';
import 'package:beautician/data/repositories/gallery_repository.dart';
import 'package:beautician/data/repositories/review_repository.dart';
import 'package:beautician/data/repositories/service_repository.dart';
import 'package:beautician/domain/models/about_content_model.dart';
import 'package:beautician/domain/models/beautician_model.dart';
import 'package:beautician/domain/models/booking_model.dart';
import 'package:beautician/domain/models/branding_settings_model.dart';
import 'package:beautician/domain/models/contact_enquiry_model.dart';
import 'package:beautician/domain/models/contact_info_model.dart';
import 'package:beautician/domain/models/content_status.dart';
import 'package:beautician/domain/models/gallery_item_model.dart';
import 'package:beautician/domain/models/hero_slide_model.dart';
import 'package:beautician/domain/models/review_model.dart';
import 'package:beautician/domain/models/service_model.dart';
import 'package:beautician/presentation/providers/beauticians_provider.dart';
import 'package:beautician/presentation/providers/bookings_provider.dart';
import 'package:beautician/presentation/providers/content_provider.dart';
import 'package:beautician/presentation/providers/enquiries_provider.dart';
import 'package:beautician/presentation/providers/gallery_provider.dart';
import 'package:beautician/presentation/providers/reviews_provider.dart';
import 'package:beautician/presentation/providers/services_provider.dart';

void main() {
  group('Comprehensive Admin-to-User State Reflection & Integrity Tests', () {
    late InMemoryStore store;
    late ServiceRepository serviceRepo;
    late BeauticianRepository beauticianRepo;
    late BookingRepository bookingRepo;
    late GalleryRepository galleryRepo;
    late ReviewRepository reviewRepo;
    late EnquiryRepository enquiryRepo;
    late ContentRepository contentRepo;

    setUp(() {
      store = InMemoryStore();
      InMemoryStore.resetInstance(store);

      serviceRepo = MockServiceRepository(store: store);
      beauticianRepo = MockBeauticianRepository(store: store);
      bookingRepo = MockBookingRepository(store: store);
      galleryRepo = MockGalleryRepository(store: store);
      reviewRepo = MockReviewRepository(store: store);
      enquiryRepo = MockEnquiryRepository(store: store);
      contentRepo = MockContentRepository(store: store);
    });

    tearDown(() {
      InMemoryStore.resetInstance(null);
    });

    test('1. Services: Admin creates/edits/toggles/deletes -> User app correctly reflects', () async {
      final adminProvider = ServicesProvider(serviceRepository: serviceRepo);
      final userProvider = ServicesProvider(serviceRepository: serviceRepo);

      await adminProvider.loadServices();
      await userProvider.loadServices();

      // Step A: Admin uploads new service
      const newService = ServiceModel(
        id: 'srv_diamond_glow',
        title: 'Diamond Glow Hydrafacial',
        category: 'Facial',
        price: 8500,
        durationMinutes: 90,
        description: 'Exfoliation, deep extraction and hyaluronic infusion.',
        imageUrl: 'https://example.com/facial.jpg',
        status: ContentStatus.published,
        isFeatured: true,
      );

      await adminProvider.createService(newService);

      // User provider reads
      await userProvider.loadServices();
      expect(userProvider.publishedServices.any((s) => s.id == 'srv_diamond_glow'), isTrue);
      final userView = userProvider.publishedServices.firstWhere((s) => s.id == 'srv_diamond_glow');
      expect(userView.price, equals(8500));
      expect(userView.title, equals('Diamond Glow Hydrafacial'));

      // Step B: Admin edits service price
      final updatedService = newService.copyWith(price: 9900, title: 'Diamond Glow Hydrafacial Elite');
      await adminProvider.updateService(updatedService);

      await userProvider.loadServices();
      final updatedUserView = userProvider.publishedServices.firstWhere((s) => s.id == 'srv_diamond_glow');
      expect(updatedUserView.price, equals(9900));
      expect(updatedUserView.title, equals('Diamond Glow Hydrafacial Elite'));

      // Step C: Admin moves to Draft -> User app must NOT display it
      final draftService = updatedService.copyWith(status: ContentStatus.draft);
      await adminProvider.updateService(draftService);

      await userProvider.loadServices();
      expect(userProvider.publishedServices.any((s) => s.id == 'srv_diamond_glow'), isFalse);
      expect(adminProvider.allServices.any((s) => s.id == 'srv_diamond_glow'), isTrue);

      // Step D: Admin deletes service
      await adminProvider.deleteServiceById('srv_diamond_glow');
      await userProvider.loadServices();
      expect(adminProvider.allServices.any((s) => s.id == 'srv_diamond_glow'), isFalse);
      expect(userProvider.allServices.any((s) => s.id == 'srv_diamond_glow'), isFalse);
    });

    test('2. Beauticians: Admin creates/updates/toggles status -> User booking reflection', () async {
      final adminProvider = BeauticiansProvider(beauticianRepository: beauticianRepo);
      final userProvider = BeauticiansProvider(beauticianRepository: beauticianRepo);

      await adminProvider.loadBeauticians();
      await userProvider.loadBeauticians();

      const newArtisan = BeauticianModel(
        id: 'bt_priya',
        name: 'Priya Sundaram',
        role: 'Master Hair Stylist',
        bio: 'Over 12 years creating couture red-carpet hairstyles and bridal transformations.',
        specialties: ['Balayage', 'Hair Botox', 'Bridal Updo'],
        rating: 4.95,
        reviewCount: 38,
        avatarUrl: 'https://example.com/priya.jpg',
        isActive: true,
      );

      // Admin adds artisan
      await adminProvider.createBeautician(newArtisan);
      await userProvider.loadBeauticians();

      expect(userProvider.activeBeauticians.any((b) => b.id == 'bt_priya'), isTrue);
      expect(userProvider.activeBeauticians.firstWhere((b) => b.id == 'bt_priya').name, equals('Priya Sundaram'));

      // Admin toggles active status to inactive (on leave)
      await adminProvider.toggleActiveStatus('bt_priya');
      await userProvider.loadBeauticians();

      expect(userProvider.activeBeauticians.any((b) => b.id == 'bt_priya'), isFalse);
      expect(adminProvider.allBeauticians.firstWhere((b) => b.id == 'bt_priya').isActive, isFalse);

      // Admin reactivates
      await adminProvider.toggleActiveStatus('bt_priya');
      await userProvider.loadBeauticians();
      expect(userProvider.activeBeauticians.any((b) => b.id == 'bt_priya'), isTrue);
    });

    test('3. Gallery: Admin uploads/publishes photo -> User Gallery grid reflects immediately', () async {
      final adminProvider = GalleryProvider(galleryRepository: galleryRepo);
      final userProvider = GalleryProvider(galleryRepository: galleryRepo);

      await adminProvider.loadGallery();
      await userProvider.loadGallery();

      final newPhoto = GalleryItemModel(
        id: 'gal_royal_hair',
        title: 'Rose Gold Balayage',
        category: 'Hair',
        imageUrl: 'https://example.com/gallery/rosegold.jpg',
        status: ContentStatus.published,
        createdAt: DateTime.now(),
      );

      await adminProvider.createGalleryItem(newPhoto);
      await userProvider.loadGallery();

      expect(userProvider.publishedItems.any((g) => g.id == 'gal_royal_hair'), isTrue);
      expect(userProvider.publishedItems.firstWhere((g) => g.id == 'gal_royal_hair').title, equals('Rose Gold Balayage'));

      // Admin changes to draft -> User sees 0 draft items
      await adminProvider.updateGalleryItem(newPhoto.copyWith(status: ContentStatus.draft));
      await userProvider.loadGallery();
      expect(userProvider.publishedItems.any((g) => g.id == 'gal_royal_hair'), isFalse);

      // Admin deletes
      await adminProvider.deleteGalleryItem(newPhoto);
      await userProvider.loadGallery();
      expect(userProvider.publishedItems.any((g) => g.id == 'gal_royal_hair'), isFalse);
    });

    test('4. Hero Slides & Branding: Admin changes banner/contact -> User UI receives update', () async {
      final adminProvider = ContentProvider(contentRepository: contentRepo);
      final userProvider = ContentProvider(contentRepository: contentRepo);

      await adminProvider.loadAllContent();
      await userProvider.loadAllContent();

      // Admin updates hero slide
      const newSlide = HeroSlideModel(
        id: 'hero_festive_2026',
        title: 'Festival of Elegance 2026',
        subtitle: 'Experience couture beauty artistry designed exclusively for you.',
        primaryCtaText: 'Explore Rituals',
        primaryCtaUrl: '/services',
        secondaryCtaText: 'Book VIP',
        secondaryCtaUrl: '/booking',
        imageUrl: 'https://example.com/festive.jpg',
        displayOrder: 0,
        status: ContentStatus.published,
      );

      await adminProvider.saveHeroSlide(newSlide, isNew: true);
      await userProvider.loadAllContent();

      expect(userProvider.activePublishedHeroSlides.any((s) => s.id == 'hero_festive_2026'), isTrue);
      expect(userProvider.activePublishedHeroSlides.firstWhere((s) => s.id == 'hero_festive_2026').title, equals('Festival of Elegance 2026'));

      // Admin updates About text
      const newAbout = AboutContentModel(
        id: 'abt_1',
        title: 'The Sanctuary of Pure Opulence',
        subtitle: 'Curated Beauty for Discerning Clients',
        story: 'Founded with a vision of unapologetic luxury and holistic wellbeing.',
        mission: 'To celebrate personal radiance through unmatched tranquility and refinement.',
        values: ['Artisanship', 'Integrity', 'Discretion', 'Innovation'],
        founderName: 'Aurelia Vance',
        founderRole: 'Founder & Creative Director',
        founderBio: 'World-renowned beauty visionary with two decades across Paris and Milan.',
        founderImageUrl: 'https://example.com/founder.jpg',
        credentials: ['CIDESCO Diplome', 'Vogue Beauty Awardee'],
      );

      await adminProvider.updateAboutContent(newAbout);
      await userProvider.loadAllContent();

      expect(userProvider.aboutContent?.title, equals('The Sanctuary of Pure Opulence'));
      expect(userProvider.aboutContent?.story, contains('unapologetic luxury'));

      // Admin updates Contact Info
      const newContact = ContactInfoModel(
        phone: '+1 (800) 777-AURA',
        email: 'vip@aurasalon.com',
        whatsapp: '+18007772872',
        address: '88 Diamond Blvd, Beverly Hills',
        cityStateZip: 'Beverly Hills, CA 90210',
        googleMapsEmbedUrl: 'https://maps.google.com',
        googleMapsDirectionsUrl: 'https://maps.google.com',
        weekDayHours: '9:00 AM - 9:00 PM',
        weekendHours: '10:00 AM - 7:00 PM',
        closedDays: 'Closed on National Holidays',
      );

      await adminProvider.updateContactInfo(newContact);
      await userProvider.loadAllContent();

      expect(userProvider.contactInfo?.phone, equals('+1 (800) 777-AURA'));
      expect(userProvider.contactInfo?.address, equals('88 Diamond Blvd, Beverly Hills'));

      // Admin updates Branding Settings
      const newSettings = BrandingSettingsModel(
        brandName: 'AURA ROYALE',
        tagline: 'The Gold Standard of Beauty',
        logoUrl: '',
        instagramUrl: 'https://instagram.com/auraroyale',
        facebookUrl: 'https://facebook.com/auraroyale',
        youtubeUrl: 'https://youtube.com/auraroyale',
        pinterestUrl: 'https://pinterest.com/auraroyale',
        metaDescription: 'Luxury salon & spa experiences',
      );

      await adminProvider.updateBrandingSettings(newSettings);
      await userProvider.loadAllContent();
      expect(userProvider.brandingSettings?.brandName, equals('AURA ROYALE'));
      expect(userProvider.brandingSettings?.tagline, equals('The Gold Standard of Beauty'));
    });

    test('5. User Bookings & Enquiries: User submits -> Admin CRM receives immediately with status workflows', () async {
      final userBookingProvider = BookingsProvider(bookingRepository: bookingRepo);
      final adminBookingProvider = BookingsProvider(bookingRepository: bookingRepo);
      final userEnquiryProvider = EnquiriesProvider(enquiryRepository: enquiryRepo);
      final adminEnquiryProvider = EnquiriesProvider(enquiryRepository: enquiryRepo);

      await adminBookingProvider.loadBookings();
      await adminEnquiryProvider.loadEnquiries();

      final initialBookings = adminBookingProvider.totalBookingsCount;
      final initialEnquiries = adminEnquiryProvider.allEnquiries.length;

      // User creates booking
      final newBooking = BookingModel(
        id: 'BK-E2E-TEST-99',
        customerName: 'Kavitha Raman',
        email: 'kavitha@example.com',
        phone: '+91 98401 23456',
        serviceId: 'srv_1',
        serviceTitle: 'Royal Bridal Makeover & Styling',
        beauticianId: 'bt_1',
        beauticianName: 'Ananya Deshmukh',
        priceAtBooking: 18500,
        durationMinutes: 180,
        bookingDate: DateTime.now().add(const Duration(days: 3)),
        timeSlot: '11:00 AM',
        status: BookingStatus.pending,
        createdAt: DateTime.now(),
      );

      await userBookingProvider.createBooking(newBooking);
      await adminBookingProvider.loadBookings();

      expect(adminBookingProvider.totalBookingsCount, equals(initialBookings + 1));
      final receivedBooking = adminBookingProvider.allBookings.firstWhere((b) => b.id == 'BK-E2E-TEST-99');
      expect(receivedBooking.customerName, equals('Kavitha Raman'));
      expect(receivedBooking.status, equals(BookingStatus.pending));

      // Admin confirms booking
      await adminBookingProvider.updateBookingStatus('BK-E2E-TEST-99', BookingStatus.confirmed);
      await userBookingProvider.loadBookings();
      final confirmed = userBookingProvider.allBookings.firstWhere((b) => b.id == 'BK-E2E-TEST-99');
      expect(confirmed.status, equals(BookingStatus.confirmed));

      // User submits Enquiry
      final success = await userEnquiryProvider.submitEnquiry(
        name: 'Sneha Patel',
        email: 'sneha@example.com',
        phone: '+91 98840 55555',
        subject: 'Bridal Party Inquiry for 6 Guests',
        message: 'Looking for bridal packages on December 15th.',
      );
      expect(success, isTrue);

      await adminEnquiryProvider.loadEnquiries();
      expect(adminEnquiryProvider.allEnquiries.length, equals(initialEnquiries + 1));
      final receivedEnq = adminEnquiryProvider.allEnquiries.firstWhere((e) => e.subject == 'Bridal Party Inquiry for 6 Guests');
      expect(receivedEnq.name, equals('Sneha Patel'));
      expect(receivedEnq.status, equals(EnquiryStatus.newEnquiry));

      // Admin updates status to read
      await adminEnquiryProvider.updateStatus(receivedEnq.id, EnquiryStatus.read);
      await userEnquiryProvider.loadEnquiries();
      expect(userEnquiryProvider.allEnquiries.firstWhere((e) => e.id == receivedEnq.id).status, equals(EnquiryStatus.read));
    });

    test('6. Reviews: Client Review moderation cycle preserves sync', () async {
      final adminReviewProvider = ReviewsProvider(reviewRepository: reviewRepo);
      final userReviewProvider = ReviewsProvider(reviewRepository: reviewRepo);

      await adminReviewProvider.loadReviews();
      await userReviewProvider.loadReviews();

      final newReview = ReviewModel(
        id: 'rev_shreya',
        clientName: 'Shreya Kapoor',
        serviceName: '24K Gold Luxury Facial',
        comment: 'Exquisite ambiance and immediate visible glow. Absolutely worth every rupee!',
        rating: 5,
        status: ContentStatus.published,
        date: DateTime.now(),
      );

      await adminReviewProvider.createReview(newReview);
      await userReviewProvider.loadReviews();

      expect(userReviewProvider.publishedReviews.any((r) => r.id == 'rev_shreya'), isTrue);
      expect(userReviewProvider.publishedReviews.firstWhere((r) => r.id == 'rev_shreya').rating, equals(5));

      // Admin unpublishes / archives review
      await adminReviewProvider.updateReview(newReview.copyWith(status: ContentStatus.draft));
      await userReviewProvider.loadReviews();
      expect(userReviewProvider.publishedReviews.any((r) => r.id == 'rev_shreya'), isFalse);
    });
  });
}
