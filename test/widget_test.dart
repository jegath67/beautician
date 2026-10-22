import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:beautician/data/repositories/auth_repository.dart';
import 'package:beautician/data/repositories/audit_repository.dart';
import 'package:beautician/data/repositories/service_repository.dart';
import 'package:beautician/data/repositories/beautician_repository.dart';
import 'package:beautician/data/repositories/booking_repository.dart';
import 'package:beautician/data/repositories/gallery_repository.dart';
import 'package:beautician/data/repositories/review_repository.dart';
import 'package:beautician/data/repositories/enquiry_repository.dart';
import 'package:beautician/data/repositories/content_repository.dart';
import 'package:beautician/data/datasources/in_memory_store.dart';
import 'package:beautician/presentation/providers/auth_provider.dart';
import 'package:beautician/presentation/providers/audit_provider.dart';
import 'package:beautician/presentation/providers/services_provider.dart';
import 'package:beautician/presentation/providers/beauticians_provider.dart';
import 'package:beautician/presentation/providers/bookings_provider.dart';
import 'package:beautician/presentation/providers/gallery_provider.dart';
import 'package:beautician/presentation/providers/reviews_provider.dart';
import 'package:beautician/presentation/providers/enquiries_provider.dart';
import 'package:beautician/presentation/providers/content_provider.dart';
import 'package:beautician/presentation/providers/theme_provider.dart';
import 'package:beautician/core/router/app_router.dart';
import 'package:beautician/core/theme/app_theme.dart';

/// A test harness that wires all mock repositories without requiring Firebase.
Widget buildTestApp() {
  final inMemoryStore = InMemoryStore.instance;
  final authRepo = MockAuthRepository(store: inMemoryStore);
  final auditRepo = MockAuditRepository(store: inMemoryStore);
  final serviceRepo = MockServiceRepository();
  final beauticianRepo = MockBeauticianRepository();
  final bookingRepo = MockBookingRepository();
  final galleryRepo = MockGalleryRepository();
  final reviewRepo = MockReviewRepository();
  final enquiryRepo = MockEnquiryRepository();
  final contentRepo = MockContentRepository();

  return MultiProvider(
    providers: [
      Provider<InMemoryStore>.value(value: inMemoryStore),
      Provider<AuthRepository>.value(value: authRepo),
      Provider<AuditRepository>.value(value: auditRepo),
      Provider<ServiceRepository>.value(value: serviceRepo),
      Provider<BeauticianRepository>.value(value: beauticianRepo),
      Provider<BookingRepository>.value(value: bookingRepo),
      Provider<GalleryRepository>.value(value: galleryRepo),
      Provider<ReviewRepository>.value(value: reviewRepo),
      Provider<EnquiryRepository>.value(value: enquiryRepo),
      Provider<ContentRepository>.value(value: contentRepo),
      ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ChangeNotifierProxyProvider<AuthRepository, AuthProvider>(
        create: (ctx) => AuthProvider(authRepository: ctx.read<AuthRepository>()),
        update: (_, repo, prev) => prev ?? AuthProvider(authRepository: repo),
      ),
      ChangeNotifierProxyProvider<AuditRepository, AuditProvider>(
        create: (ctx) => AuditProvider(auditRepository: ctx.read<AuditRepository>()),
        update: (_, repo, prev) => prev ?? AuditProvider(auditRepository: repo),
      ),
      ChangeNotifierProxyProvider2<ServiceRepository, AuditProvider, ServicesProvider>(
        create: (ctx) => ServicesProvider(
          serviceRepository: ctx.read<ServiceRepository>(),
          auditProvider: ctx.read<AuditProvider>(),
        ),
        update: (_, repo, audit, prev) =>
            prev ?? ServicesProvider(serviceRepository: repo, auditProvider: audit),
      ),
      ChangeNotifierProxyProvider2<BeauticianRepository, AuditProvider, BeauticiansProvider>(
        create: (ctx) => BeauticiansProvider(
          beauticianRepository: ctx.read<BeauticianRepository>(),
          auditProvider: ctx.read<AuditProvider>(),
        ),
        update: (_, repo, audit, prev) =>
            prev ?? BeauticiansProvider(beauticianRepository: repo, auditProvider: audit),
      ),
      ChangeNotifierProxyProvider2<BookingRepository, AuditProvider, BookingsProvider>(
        create: (ctx) => BookingsProvider(
          bookingRepository: ctx.read<BookingRepository>(),
          auditProvider: ctx.read<AuditProvider>(),
        ),
        update: (_, repo, audit, prev) =>
            prev ?? BookingsProvider(bookingRepository: repo, auditProvider: audit),
      ),
      ChangeNotifierProxyProvider2<GalleryRepository, AuditProvider, GalleryProvider>(
        create: (ctx) => GalleryProvider(
          galleryRepository: ctx.read<GalleryRepository>(),
          auditProvider: ctx.read<AuditProvider>(),
        ),
        update: (_, repo, audit, prev) =>
            prev ?? GalleryProvider(galleryRepository: repo, auditProvider: audit),
      ),
      ChangeNotifierProxyProvider2<ReviewRepository, AuditProvider, ReviewsProvider>(
        create: (ctx) => ReviewsProvider(
          reviewRepository: ctx.read<ReviewRepository>(),
          auditProvider: ctx.read<AuditProvider>(),
        ),
        update: (_, repo, audit, prev) =>
            prev ?? ReviewsProvider(reviewRepository: repo, auditProvider: audit),
      ),
      ChangeNotifierProxyProvider2<EnquiryRepository, AuditProvider, EnquiriesProvider>(
        create: (ctx) => EnquiriesProvider(
          enquiryRepository: ctx.read<EnquiryRepository>(),
          auditProvider: ctx.read<AuditProvider>(),
        ),
        update: (_, repo, audit, prev) =>
            prev ?? EnquiriesProvider(enquiryRepository: repo, auditProvider: audit),
      ),
      ChangeNotifierProxyProvider2<ContentRepository, AuditProvider, ContentProvider>(
        create: (ctx) => ContentProvider(
          contentRepository: ctx.read<ContentRepository>(),
          auditProvider: ctx.read<AuditProvider>(),
        ),
        update: (_, repo, audit, prev) =>
            prev ?? ContentProvider(contentRepository: repo, auditProvider: audit),
      ),
    ],
    child: Builder(
      builder: (context) {
        final authProvider = context.watch<AuthProvider>();
        final themeProvider = context.watch<ThemeProvider>();
        return MaterialApp.router(
          title: 'Beautician CMS',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeProvider.themeMode,
          routerConfig: AppRouter.createRouter(authProvider),
        );
      },
    ),
  );
}

void main() {
  testWidgets('App initializes successfully with responsive shell', (WidgetTester tester) async {
    // Set desktop surface size to avoid narrow-viewport overflows
    await tester.binding.setSurfaceSize(const Size(1440, 900));
    tester.view.physicalSize = const Size(1440, 900);
    tester.view.devicePixelRatio = 1.0;

    addTearDown(() async {
      await tester.binding.setSurfaceSize(null);
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(buildTestApp());

    // Allow providers to load initial data and router to render
    await tester.pump(const Duration(milliseconds: 500));

    // Verify the MaterialApp is present in the widget tree
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
