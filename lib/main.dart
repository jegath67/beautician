import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:provider/provider.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'data/repositories/audit_repository.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/beautician_repository.dart';
import 'data/repositories/booking_repository.dart';
import 'data/repositories/content_repository.dart';
import 'data/repositories/enquiry_repository.dart';
import 'data/repositories/gallery_repository.dart';
import 'data/repositories/review_repository.dart';
import 'data/repositories/service_repository.dart';
import 'data/repositories/firestore_beautician_repository.dart';
import 'data/repositories/firestore_booking_repository.dart';
import 'data/repositories/firestore_content_repository.dart';
import 'data/repositories/firestore_enquiry_repository.dart';
import 'data/repositories/firestore_gallery_repository.dart';
import 'data/repositories/firestore_review_repository.dart';
import 'data/repositories/firestore_service_repository.dart';
import 'data/repositories/firebase_auth_repository.dart';
import 'data/datasources/in_memory_store.dart';
import 'firebase_options.dart';
import 'presentation/providers/audit_provider.dart';
import 'presentation/providers/auth_provider.dart';
import 'presentation/providers/beauticians_provider.dart';
import 'presentation/providers/bookings_provider.dart';
import 'presentation/providers/content_provider.dart';
import 'presentation/providers/enquiries_provider.dart';
import 'presentation/providers/gallery_provider.dart';
import 'presentation/providers/reviews_provider.dart';
import 'presentation/providers/services_provider.dart';
import 'presentation/providers/theme_provider.dart';

void main() async {
  // Ensure Flutter engine bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Configure clean path URLs (removes '#' hash from web URLs for SEO and clean deep linking)
  usePathUrlStrategy();

  // Initialize Firebase before running the app
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const BeauticianApp());
}

class BeauticianApp extends StatelessWidget {
  final AuthRepository? authRepository;
  final AuditRepository? auditRepository;
  final ServiceRepository? serviceRepository;
  final BeauticianRepository? beauticianRepository;
  final BookingRepository? bookingRepository;
  final GalleryRepository? galleryRepository;
  final ReviewRepository? reviewRepository;
  final EnquiryRepository? enquiryRepository;
  final ContentRepository? contentRepository;

  const BeauticianApp({
    super.key,
    this.authRepository,
    this.auditRepository,
    this.serviceRepository,
    this.beauticianRepository,
    this.bookingRepository,
    this.galleryRepository,
    this.reviewRepository,
    this.enquiryRepository,
    this.contentRepository,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // 1. Shared In-Memory Store (kept for AuditRepository which has no Firestore impl yet)
        Provider<InMemoryStore>.value(value: InMemoryStore.instance),

        // 2. Repositories — wired to Firebase & Firestore
        Provider<AuthRepository>(
          create: (_) => authRepository ?? FirebaseAuthRepository(),
        ),
        Provider<AuditRepository>(
          create: (_) =>
              auditRepository ??
              MockAuditRepository(store: InMemoryStore.instance),
        ),
        Provider<ServiceRepository>(
          create: (_) => serviceRepository ?? FirestoreServiceRepository(),
        ),
        Provider<BeauticianRepository>(
          create: (_) =>
              beauticianRepository ?? FirestoreBeauticianRepository(),
        ),
        Provider<BookingRepository>(
          create: (_) => bookingRepository ?? FirestoreBookingRepository(),
        ),
        Provider<GalleryRepository>(
          create: (_) => galleryRepository ?? FirestoreGalleryRepository(),
        ),
        Provider<ReviewRepository>(
          create: (_) => reviewRepository ?? FirestoreReviewRepository(),
        ),
        Provider<EnquiryRepository>(
          create: (_) => enquiryRepository ?? FirestoreEnquiryRepository(),
        ),
        Provider<ContentRepository>(
          create: (_) => contentRepository ?? FirestoreContentRepository(),
        ),

        // 3. Presentation State Layer (Providers injected with shared Repositories)
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProxyProvider<AuthRepository, AuthProvider>(
          create: (ctx) =>
              AuthProvider(authRepository: ctx.read<AuthRepository>()),
          update: (_, repo, auth) => auth ?? AuthProvider(authRepository: repo),
        ),
        ChangeNotifierProxyProvider<AuditRepository, AuditProvider>(
          create: (ctx) =>
              AuditProvider(auditRepository: ctx.read<AuditRepository>()),
          update: (_, repo, audit) =>
              audit ?? AuditProvider(auditRepository: repo),
        ),
        ChangeNotifierProxyProvider2<
          ServiceRepository,
          AuditProvider,
          ServicesProvider
        >(
          create: (ctx) => ServicesProvider(
            serviceRepository: ctx.read<ServiceRepository>(),
            auditProvider: ctx.read<AuditProvider>(),
          ),
          update: (_, repo, audit, services) =>
              services ??
              ServicesProvider(serviceRepository: repo, auditProvider: audit),
        ),
        ChangeNotifierProxyProvider2<
          BeauticianRepository,
          AuditProvider,
          BeauticiansProvider
        >(
          create: (ctx) => BeauticiansProvider(
            beauticianRepository: ctx.read<BeauticianRepository>(),
            auditProvider: ctx.read<AuditProvider>(),
          ),
          update: (_, repo, audit, beauticians) =>
              beauticians ??
              BeauticiansProvider(
                beauticianRepository: repo,
                auditProvider: audit,
              ),
        ),
        ChangeNotifierProxyProvider2<
          BookingRepository,
          AuditProvider,
          BookingsProvider
        >(
          create: (ctx) => BookingsProvider(
            bookingRepository: ctx.read<BookingRepository>(),
            auditProvider: ctx.read<AuditProvider>(),
          ),
          update: (_, repo, audit, bookings) =>
              bookings ??
              BookingsProvider(bookingRepository: repo, auditProvider: audit),
        ),
        ChangeNotifierProxyProvider2<
          GalleryRepository,
          AuditProvider,
          GalleryProvider
        >(
          create: (ctx) => GalleryProvider(
            galleryRepository: ctx.read<GalleryRepository>(),
            auditProvider: ctx.read<AuditProvider>(),
          ),
          update: (_, repo, audit, gallery) =>
              gallery ??
              GalleryProvider(galleryRepository: repo, auditProvider: audit),
        ),
        ChangeNotifierProxyProvider2<
          ReviewRepository,
          AuditProvider,
          ReviewsProvider
        >(
          create: (ctx) => ReviewsProvider(
            reviewRepository: ctx.read<ReviewRepository>(),
            auditProvider: ctx.read<AuditProvider>(),
          ),
          update: (_, repo, audit, reviews) =>
              reviews ??
              ReviewsProvider(reviewRepository: repo, auditProvider: audit),
        ),
        ChangeNotifierProxyProvider2<
          EnquiryRepository,
          AuditProvider,
          EnquiriesProvider
        >(
          create: (ctx) => EnquiriesProvider(
            enquiryRepository: ctx.read<EnquiryRepository>(),
            auditProvider: ctx.read<AuditProvider>(),
          ),
          update: (_, repo, audit, enquiries) =>
              enquiries ??
              EnquiriesProvider(enquiryRepository: repo, auditProvider: audit),
        ),
        ChangeNotifierProxyProvider2<
          ContentRepository,
          AuditProvider,
          ContentProvider
        >(
          create: (ctx) => ContentProvider(
            contentRepository: ctx.read<ContentRepository>(),
            auditProvider: ctx.read<AuditProvider>(),
          ),
          update: (_, repo, audit, content) =>
              content ??
              ContentProvider(contentRepository: repo, auditProvider: audit),
        ),
      ],
      child: Consumer2<ThemeProvider, AuthProvider>(
        builder: (context, themeProvider, authProvider, _) {
          final router = AppRouter.createRouter(authProvider);

          return MaterialApp.router(
            title: 'AURA & CO. | Luxury Beautician Salon & Spa',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            routerConfig: router,
            builder: (context, child) {
              // Ensure accessibility semantics and unhindered text scaling across zoom levels
              return MediaQuery(
                data: MediaQuery.of(context),
                child: child ?? const SizedBox.shrink(),
              );
            },
          );
        },
      ),
    );
  }
}
