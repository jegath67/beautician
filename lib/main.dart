import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:provider/provider.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
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

void main() {
  // Ensure Flutter engine bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Configure clean path URLs (removes '#' hash from web URLs for SEO and clean deep linking)
  usePathUrlStrategy();

  runApp(const BeauticianApp());
}

class BeauticianApp extends StatelessWidget {
  const BeauticianApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => AuditProvider()),
        ChangeNotifierProxyProvider<AuditProvider, ServicesProvider>(
          create: (ctx) => ServicesProvider(auditProvider: ctx.read<AuditProvider>()),
          update: (_, audit, services) => services ?? ServicesProvider(auditProvider: audit),
        ),
        ChangeNotifierProxyProvider<AuditProvider, BeauticiansProvider>(
          create: (ctx) => BeauticiansProvider(auditProvider: ctx.read<AuditProvider>()),
          update: (_, audit, beauticians) => beauticians ?? BeauticiansProvider(auditProvider: audit),
        ),
        ChangeNotifierProxyProvider<AuditProvider, BookingsProvider>(
          create: (ctx) => BookingsProvider(auditProvider: ctx.read<AuditProvider>()),
          update: (_, audit, bookings) => bookings ?? BookingsProvider(auditProvider: audit),
        ),
        ChangeNotifierProxyProvider<AuditProvider, GalleryProvider>(
          create: (ctx) => GalleryProvider(auditProvider: ctx.read<AuditProvider>()),
          update: (_, audit, gallery) => gallery ?? GalleryProvider(auditProvider: audit),
        ),
        ChangeNotifierProxyProvider<AuditProvider, ReviewsProvider>(
          create: (ctx) => ReviewsProvider(auditProvider: ctx.read<AuditProvider>()),
          update: (_, audit, reviews) => reviews ?? ReviewsProvider(auditProvider: audit),
        ),
        ChangeNotifierProxyProvider<AuditProvider, EnquiriesProvider>(
          create: (ctx) => EnquiriesProvider(auditProvider: ctx.read<AuditProvider>()),
          update: (_, audit, enquiries) => enquiries ?? EnquiriesProvider(auditProvider: audit),
        ),
        ChangeNotifierProxyProvider<AuditProvider, ContentProvider>(
          create: (ctx) => ContentProvider(auditProvider: ctx.read<AuditProvider>()),
          update: (_, audit, content) => content ?? ContentProvider(auditProvider: audit),
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
