import 'package:flutter_test/flutter_test.dart';
import 'package:beautician/data/datasources/in_memory_store.dart';
import 'package:beautician/data/repositories/beautician_repository.dart';
import 'package:beautician/data/repositories/booking_repository.dart';
import 'package:beautician/data/repositories/service_repository.dart';
import 'package:beautician/domain/models/beautician_model.dart';
import 'package:beautician/domain/models/booking_model.dart';
import 'package:beautician/domain/models/content_status.dart';
import 'package:beautician/domain/models/service_model.dart';
import 'package:beautician/presentation/providers/beauticians_provider.dart';
import 'package:beautician/presentation/providers/bookings_provider.dart';
import 'package:beautician/presentation/providers/services_provider.dart';

void main() {
  group('P0.1 Shared Repository & In-Memory State Tests', () {
    late InMemoryStore store;
    late ServiceRepository serviceRepo;
    late BeauticianRepository beauticianRepo;
    late BookingRepository bookingRepo;

    setUp(() {
      // Create a fresh shared store for the test scenario
      store = InMemoryStore();
      InMemoryStore.resetInstance(store);

      serviceRepo = MockServiceRepository(store: store);
      beauticianRepo = MockBeauticianRepository(store: store);
      bookingRepo = MockBookingRepository(store: store);
    });

    tearDown(() {
      InMemoryStore.resetInstance(null);
    });

    test(
      'Single source of truth: repositories share same underlying store',
      () async {
        final repo1 = MockServiceRepository(store: store);
        final repo2 = MockServiceRepository(store: store);

        final initialServices = await repo1.getServices();
        expect(initialServices.length, 8);

        const newService = ServiceModel(
          id: 'srv_test_di',
          title: 'DI Shared Service',
          category: 'Skin',
          price: 3999,
          durationMinutes: 60,
          description:
              'Testing shared store reference across multiple repository instances.',
          imageUrl: 'https://example.com/test.jpg',
          status: ContentStatus.published,
        );

        await repo1.createService(newService);

        final fromRepo2 = await repo2.getServiceById('srv_test_di');
        expect(fromRepo2, isNotNull);
        expect(fromRepo2!.title, equals('DI Shared Service'));
        expect(fromRepo2.price, equals(3999));
      },
    );

    test(
      'Test 1 — Admin creates service: reflected in Public/User reads',
      () async {
        // Simulate Admin provider and Public provider backed by shared repository/store
        final adminServicesProvider = ServicesProvider(
          serviceRepository: serviceRepo,
        );
        final publicServicesProvider = ServicesProvider(
          serviceRepository: serviceRepo,
        );

        await adminServicesProvider.loadServices();
        await publicServicesProvider.loadServices();

        const newService = ServiceModel(
          id: 'srv_new_bridal',
          title: 'Vogue Couture Bridal Package',
          category: 'Bridal',
          price: 25000,
          durationMinutes: 240,
          description:
              'Elite royal bridal makeover with diamond airbrush artistry.',
          imageUrl: 'https://example.com/vogue.jpg',
          status: ContentStatus.published,
          isFeatured: true,
        );

        // Admin creates service
        await adminServicesProvider.createService(
          newService,
          actorName: 'Admin Manager',
        );

        // Verify Admin list contains it
        expect(
          adminServicesProvider.allServices.any(
            (s) => s.id == 'srv_new_bridal',
          ),
          isTrue,
        );

        // Public provider reads the same updated data
        await publicServicesProvider.loadServices();
        expect(
          publicServicesProvider.publishedServices.any(
            (s) => s.id == 'srv_new_bridal',
          ),
          isTrue,
        );
        final publicService = publicServicesProvider.publishedServices
            .firstWhere((s) => s.id == 'srv_new_bridal');
        expect(publicService.title, equals('Vogue Couture Bridal Package'));
        expect(publicService.price, equals(25000));
      },
    );

    test(
      'Test 2 — Admin edits service: updated values immediately reflected',
      () async {
        final adminServicesProvider = ServicesProvider(
          serviceRepository: serviceRepo,
        );
        final publicServicesProvider = ServicesProvider(
          serviceRepository: serviceRepo,
        );

        await adminServicesProvider.loadServices();
        await publicServicesProvider.loadServices();

        final existing = adminServicesProvider.allServices.firstWhere(
          (s) => s.id == 'srv_1',
        );
        final updated = existing.copyWith(
          title: 'Imperial Bridal Makeover & Ultra-Luxe Styling',
          price: 22000,
          durationMinutes: 210,
        );

        // Admin updates service
        await adminServicesProvider.updateService(
          updated,
          previousService: existing,
        );

        // Public side sees updated values
        await publicServicesProvider.loadServices();
        final publicService = publicServicesProvider.allServices.firstWhere(
          (s) => s.id == 'srv_1',
        );
        expect(
          publicService.title,
          equals('Imperial Bridal Makeover & Ultra-Luxe Styling'),
        );
        expect(publicService.price, equals(22000));
        expect(publicService.durationMinutes, equals(210));
      },
    );

    test(
      'Test 3 — Admin deletes service: disappears from Admin and Public',
      () async {
        final adminServicesProvider = ServicesProvider(
          serviceRepository: serviceRepo,
        );
        final publicServicesProvider = ServicesProvider(
          serviceRepository: serviceRepo,
        );

        await adminServicesProvider.loadServices();
        await publicServicesProvider.loadServices();

        // Verify srv_4 is initially present
        expect(
          adminServicesProvider.allServices.any((s) => s.id == 'srv_4'),
          isTrue,
        );

        final toDelete = adminServicesProvider.allServices.firstWhere(
          (s) => s.id == 'srv_4',
        );
        await adminServicesProvider.deleteService(toDelete);

        // Verify it disappeared from Admin
        expect(
          adminServicesProvider.allServices.any((s) => s.id == 'srv_4'),
          isFalse,
        );

        // Verify it disappeared from Public
        await publicServicesProvider.loadServices();
        expect(
          publicServicesProvider.allServices.any((s) => s.id == 'srv_4'),
          isFalse,
        );
        expect(
          publicServicesProvider.publishedServices.any((s) => s.id == 'srv_4'),
          isFalse,
        );
      },
    );

    test(
      'Test 4 — Beautician: create, edit, toggle active, and delete operations share state',
      () async {
        final adminBeauticiansProvider = BeauticiansProvider(
          beauticianRepository: beauticianRepo,
        );
        final publicBeauticiansProvider = BeauticiansProvider(
          beauticianRepository: beauticianRepo,
        );

        await adminBeauticiansProvider.loadBeauticians();
        await publicBeauticiansProvider.loadBeauticians();

        const newBeautician = BeauticianModel(
          id: 'bt_new_4',
          name: 'Zara Alvi',
          role: 'Bridal Henna & Draping Artist',
          bio:
              '10 years specialized in organic Rajasthani and Arabic henna artistry.',
          specialties: ['Bridal Mehndi', 'Dupatta Draping'],
          avatarUrl: 'https://example.com/zara.jpg',
          workingDays: [1, 2, 3, 4, 5],
          workingHoursStart: '09:00',
          workingHoursEnd: '18:00',
          breakStart: '13:00',
          breakEnd: '14:00',
          isActive: true,
        );

        // 1. Create
        await adminBeauticiansProvider.createBeautician(newBeautician);
        await publicBeauticiansProvider.loadBeauticians();

        expect(
          publicBeauticiansProvider.activeBeauticians.any(
            (b) => b.id == 'bt_new_4',
          ),
          isTrue,
        );

        // 2. Edit
        final updatedBeautician = newBeautician.copyWith(
          name: 'Zara Alvi-Khan',
        );
        await adminBeauticiansProvider.updateBeautician(updatedBeautician);
        await publicBeauticiansProvider.loadBeauticians();

        final publicBeautician = publicBeauticiansProvider.allBeauticians
            .firstWhere((b) => b.id == 'bt_new_4');
        expect(publicBeautician.name, equals('Zara Alvi-Khan'));

        // 3. Toggle inactive -> should disappear from public active list
        await adminBeauticiansProvider.toggleActiveStatus('bt_new_4');
        await publicBeauticiansProvider.loadBeauticians();

        expect(
          publicBeauticiansProvider.activeBeauticians.any(
            (b) => b.id == 'bt_new_4',
          ),
          isFalse,
        );
        expect(
          publicBeauticiansProvider.allBeauticians.any(
            (b) => b.id == 'bt_new_4',
          ),
          isTrue,
        );

        // 4. Delete
        await adminBeauticiansProvider.deleteBeauticianById('bt_new_4');
        await publicBeauticiansProvider.loadBeauticians();

        expect(
          adminBeauticiansProvider.allBeauticians.any(
            (b) => b.id == 'bt_new_4',
          ),
          isFalse,
        );
        expect(
          publicBeauticiansProvider.allBeauticians.any(
            (b) => b.id == 'bt_new_4',
          ),
          isFalse,
        );
      },
    );

    test(
      'Test 5 — Public creates booking: reflected in Admin dashboard & list',
      () async {
        final bookingsProvider = BookingsProvider(
          bookingRepository: bookingRepo,
        );
        await bookingsProvider.loadBookings();

        final initialCount = bookingsProvider.totalBookingsCount;

        final booking = BookingModel(
          id: 'BK-TEST-SHARED-1',
          customerName: 'Tara Sharma',
          email: 'tara@example.com',
          phone: '+91 99999 88888',
          serviceId: 'srv_1',
          serviceTitle: 'Royal Bridal Makeover & Styling',
          beauticianId: 'bt_1',
          beauticianName: 'Ananya Deshmukh',
          priceAtBooking: 18500,
          durationMinutes: 180,
          bookingDate: DateTime.now().add(const Duration(days: 5)),
          timeSlot: '10:00 AM',
          status: BookingStatus.pending,
          createdAt: DateTime.now(),
        );

        // Public creates booking
        await bookingsProvider.createBooking(booking);

        // Both Admin view (reading same provider or same repository) see the booking
        expect(bookingsProvider.totalBookingsCount, equals(initialCount + 1));
        expect(bookingsProvider.pendingBookingsCount, greaterThan(0));

        final directFromStore = store.bookings.firstWhere(
          (b) => b.id == 'BK-TEST-SHARED-1',
        );
        expect(directFromStore.customerName, equals('Tara Sharma'));

        // Admin updates booking status
        await bookingsProvider.updateBookingStatus(
          'BK-TEST-SHARED-1',
          BookingStatus.confirmed,
        );
        final confirmedInStore = store.bookings.firstWhere(
          (b) => b.id == 'BK-TEST-SHARED-1',
        );
        expect(confirmedInStore.status, equals(BookingStatus.confirmed));
      },
    );

    test(
      'Test 6 — Existing mock seed data and relationships preserved',
      () async {
        // 8 services
        expect(store.services.length, equals(8));
        expect(store.services.first.id, equals('srv_1'));
        expect(
          store.services.first.title,
          equals('Royal Bridal Makeover & Styling'),
        );
        expect(store.services.first.price, equals(18500));

        // 3 beauticians
        expect(store.beauticians.length, equals(3));
        expect(store.beauticians.first.id, equals('bt_1'));
        expect(store.beauticians.first.name, equals('Ananya Deshmukh'));

        // 4 bookings
        expect(store.bookings.length, equals(4));
        expect(store.bookings.any((b) => b.id == 'BK-10821'), isTrue);
        // Relationship integrity: booking references existing service and beautician
        final booking = store.bookings.firstWhere((b) => b.id == 'BK-10821');
        expect(store.services.any((s) => s.id == booking.serviceId), isTrue);
        expect(
          store.beauticians.any((b) => b.id == booking.beauticianId),
          isTrue,
        );

        // 8 gallery items
        expect(store.galleryItems.length, equals(8));

        // 4 reviews
        expect(store.reviews.length, equals(4));

        // 2 enquiries
        expect(store.enquiries.length, equals(2));

        // Content & Branding
        expect(store.heroSlides.length, equals(3));
        expect(store.aboutContent.id, equals('abt_1'));
        expect(store.brandingSettings.brandName, equals('AURA & CO.'));

        // 3 audit logs
        expect(store.auditLogs.length, equals(3));
      },
    );
  });
}
