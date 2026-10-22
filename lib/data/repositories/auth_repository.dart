import '../../domain/models/user_model.dart';
import '../datasources/in_memory_store.dart';

abstract class AuthRepository {
  Future<UserModel?> getCurrentUser();
  Future<UserModel> login({required String email, required String password});
  Future<void> logout();
  bool get isAuthenticated;
}

class MockAuthRepository implements AuthRepository {
  final InMemoryStore _store;

  MockAuthRepository({InMemoryStore? store})
    : _store = store ?? InMemoryStore.instance;

  static const UserModel demoAdminUser = UserModel(
    id: 'usr_admin',
    name: 'Priya Sharma (Manager)',
    email: 'admin@aurabeauty.com',
    role: UserRole.superAdmin,
    avatarUrl:
        'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?auto=format&fit=crop&w=200&q=80',
  );

  @override
  Future<UserModel?> getCurrentUser() async {
    return _store.currentUser;
  }

  @override
  bool get isAuthenticated => _store.currentUser != null;

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    // Demo validation
    if (email.trim().toLowerCase() == 'admin@aurabeauty.com' &&
        password == 'admin123') {
      _store.currentUser = demoAdminUser;
      return _store.currentUser!;
    }
    // Allow any demo login if email starts with admin
    if (email.contains('admin') || password.length >= 6) {
      _store.currentUser = UserModel(
        id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
        name: email.split('@').first.toUpperCase(),
        email: email,
        role: UserRole.manager,
      );
      return _store.currentUser!;
    }
    throw Exception('Invalid email or password. Use demo credentials.');
  }

  @override
  Future<void> logout() async {
    _store.currentUser = null;
  }
}
