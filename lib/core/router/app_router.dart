import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/admin/about/screens/admin_about_screen.dart';
import '../../features/admin/audit_logs/screens/admin_audit_logs_screen.dart';
import '../../features/admin/beauticians/screens/admin_beauticians_screen.dart';
import '../../features/admin/bookings/screens/admin_bookings_screen.dart';
import '../../features/admin/contact/screens/admin_contact_screen.dart';
import '../../features/admin/dashboard/screens/admin_dashboard_screen.dart';
import '../../features/admin/enquiries/screens/admin_enquiries_screen.dart';
import '../../features/admin/gallery/screens/admin_gallery_screen.dart';
import '../../features/admin/hero/screens/admin_hero_screen.dart';
import '../../features/admin/reviews/screens/admin_reviews_screen.dart';
import '../../features/admin/services/screens/admin_services_screen.dart';
import '../../features/admin/settings/screens/admin_settings_screen.dart';
import '../../features/auth/screens/admin_login_screen.dart';
import '../../features/user/about/screens/about_screen.dart';
import '../../features/user/bookings/screens/booking_screen.dart';
import '../../features/user/contact/screens/contact_screen.dart';
import '../../features/user/gallery/screens/gallery_screen.dart';
import '../../features/user/home/screens/home_screen.dart';
import '../../features/user/services/screens/services_screen.dart';
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
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: services,
          name: 'services',
          builder: (context, state) => const ServicesScreen(),
        ),
        GoRoute(
          path: gallery,
          name: 'gallery',
          builder: (context, state) => const GalleryScreen(),
        ),
        GoRoute(
          path: booking,
          name: 'booking',
          builder: (context, state) => const BookingScreen(),
        ),
        GoRoute(
          path: about,
          name: 'about',
          builder: (context, state) => const AboutScreen(),
        ),
        GoRoute(
          path: contact,
          name: 'contact',
          builder: (context, state) => const ContactScreen(),
        ),
        GoRoute(
          path: adminLogin,
          name: 'adminLogin',
          builder: (context, state) => const AdminLoginScreen(),
        ),
        GoRoute(
          path: adminDashboard,
          name: 'adminDashboard',
          builder: (context, state) => const AdminDashboardScreen(),
        ),
        GoRoute(
          path: adminHero,
          name: 'adminHero',
          builder: (context, state) => const AdminHeroScreen(),
        ),
        GoRoute(
          path: adminServices,
          name: 'adminServices',
          builder: (context, state) => const AdminServicesScreen(),
        ),
        GoRoute(
          path: adminBeauticians,
          name: 'adminBeauticians',
          builder: (context, state) => const AdminBeauticiansScreen(),
        ),
        GoRoute(
          path: adminGallery,
          name: 'adminGallery',
          builder: (context, state) => const AdminGalleryScreen(),
        ),
        GoRoute(
          path: adminBookings,
          name: 'adminBookings',
          builder: (context, state) => const AdminBookingsScreen(),
        ),
        GoRoute(
          path: adminReviews,
          name: 'adminReviews',
          builder: (context, state) => const AdminReviewsScreen(),
        ),
        GoRoute(
          path: adminEnquiries,
          name: 'adminEnquiries',
          builder: (context, state) => const AdminEnquiriesScreen(),
        ),
        GoRoute(
          path: adminAbout,
          name: 'adminAbout',
          builder: (context, state) => const AdminAboutScreen(),
        ),
        GoRoute(
          path: adminContact,
          name: 'adminContact',
          builder: (context, state) => const AdminContactScreen(),
        ),
        GoRoute(
          path: adminSettings,
          name: 'adminSettings',
          builder: (context, state) => const AdminSettingsScreen(),
        ),
        GoRoute(
          path: adminAuditLogs,
          name: 'adminAuditLogs',
          builder: (context, state) => const AdminAuditLogsScreen(),
        ),
      ],
    );
  }
}
