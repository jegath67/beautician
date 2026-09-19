import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../presentation/providers/auth_provider.dart';

class AppRouter {
  AppRouter._();

  // Public Routes
  static const String home = '/';
  static const String services = '/services';
  static const String gallery = '/gallery';
  static const String booking = '/booking';
  static const String about = '/about';
  static const String contact = '/contact';

  // Admin Routes
  static const String adminLogin = '/admin/login';
  static const String adminDashboard = '/admin/dashboard';
  static const String adminHero = '/admin/hero';
  static const String adminServices = '/admin/services';
  static const String adminBeauticians = '/admin/beauticians';
  static const String adminGallery = '/admin/gallery';
  static const String adminBookings = '/admin/bookings';
  static const String adminReviews = '/admin/reviews';
  static const String adminEnquiries = '/admin/enquiries';
  static const String adminAbout = '/admin/about';
  static const String adminContact = '/admin/contact';
  static const String adminSettings = '/admin/settings';
  static const String adminAuditLogs = '/admin/audit-logs';

  static GoRouter createRouter(AuthProvider authProvider) {
    return GoRouter(
      initialLocation: home,
      refreshListenable: authProvider,
      redirect: (context, state) {
        final location = state.matchedLocation;
        final isAdminRoute = location.startsWith('/admin');
        final isLoginRoute = location == adminLogin;

        // If user is accessing an admin route without authentication
        if (isAdminRoute && !isLoginRoute && !authProvider.isAuthenticated) {
          return adminLogin;
        }

        // If user is logged in and tries to go to login page, redirect to dashboard
        if (isLoginRoute && authProvider.isAuthenticated) {
          return adminDashboard;
        }

        return null; // Proceed to requested route
      },
      errorBuilder: (context, state) => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.amber),
              const SizedBox(height: 16),
              Text(
                '404 - Page Not Found',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                'The page "${state.uri}" does not exist.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () => context.go(home),
                icon: const Icon(Icons.home),
                label: const Text('Return to Home'),
              ),
            ],
          ),
        ),
      ),
      routes: [
        GoRoute(
          path: home,
          name: 'home',
          builder: (context, state) => const _RoutePlaceholder(title: 'Aura & Co. Home'),
        ),
        GoRoute(
          path: services,
          name: 'services',
          builder: (context, state) => const _RoutePlaceholder(title: 'Services Catalog'),
        ),
        GoRoute(
          path: gallery,
          name: 'gallery',
          builder: (context, state) => const _RoutePlaceholder(title: 'Transformation Gallery'),
        ),
        GoRoute(
          path: booking,
          name: 'booking',
          builder: (context, state) => const _RoutePlaceholder(title: 'Book Appointment'),
        ),
        GoRoute(
          path: about,
          name: 'about',
          builder: (context, state) => const _RoutePlaceholder(title: 'About Aura'),
        ),
        GoRoute(
          path: contact,
          name: 'contact',
          builder: (context, state) => const _RoutePlaceholder(title: 'Contact Concierge'),
        ),
        GoRoute(
          path: adminLogin,
          name: 'adminLogin',
          builder: (context, state) => const _RoutePlaceholder(title: 'Admin Portal Login'),
        ),
        GoRoute(
          path: adminDashboard,
          name: 'adminDashboard',
          builder: (context, state) => const _RoutePlaceholder(title: 'Admin Dashboard'),
        ),
        GoRoute(
          path: adminHero,
          name: 'adminHero',
          builder: (context, state) => const _RoutePlaceholder(title: 'Admin Hero Slides'),
        ),
        GoRoute(
          path: adminServices,
          name: 'adminServices',
          builder: (context, state) => const _RoutePlaceholder(title: 'Admin Services CMS'),
        ),
        GoRoute(
          path: adminBeauticians,
          name: 'adminBeauticians',
          builder: (context, state) => const _RoutePlaceholder(title: 'Admin Beauticians CMS'),
        ),
        GoRoute(
          path: adminGallery,
          name: 'adminGallery',
          builder: (context, state) => const _RoutePlaceholder(title: 'Admin Gallery Studio'),
        ),
        GoRoute(
          path: adminBookings,
          name: 'adminBookings',
          builder: (context, state) => const _RoutePlaceholder(title: 'Admin Bookings Management'),
        ),
        GoRoute(
          path: adminReviews,
          name: 'adminReviews',
          builder: (context, state) => const _RoutePlaceholder(title: 'Admin Reviews Moderation'),
        ),
        GoRoute(
          path: adminEnquiries,
          name: 'adminEnquiries',
          builder: (context, state) => const _RoutePlaceholder(title: 'Admin Contact Enquiries'),
        ),
        GoRoute(
          path: adminAbout,
          name: 'adminAbout',
          builder: (context, state) => const _RoutePlaceholder(title: 'Admin About Content'),
        ),
        GoRoute(
          path: adminContact,
          name: 'adminContact',
          builder: (context, state) => const _RoutePlaceholder(title: 'Admin Contact Info'),
        ),
        GoRoute(
          path: adminSettings,
          name: 'adminSettings',
          builder: (context, state) => const _RoutePlaceholder(title: 'Admin Branding Settings'),
        ),
        GoRoute(
          path: adminAuditLogs,
          name: 'adminAuditLogs',
          builder: (context, state) => const _RoutePlaceholder(title: 'Admin Activity & Audit Logs'),
        ),
      ],
    );
  }
}

class _RoutePlaceholder extends StatelessWidget {
  final String title;
  const _RoutePlaceholder({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text(
          '$title Screen Initialized',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    );
  }
}
