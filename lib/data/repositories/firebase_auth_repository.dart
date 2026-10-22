import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/models/user_model.dart';
import 'auth_repository.dart';

/// Production-ready Firebase Authentication repository with secure role-based authorization.
class FirebaseAuthRepository implements AuthRepository {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  FirebaseAuthRepository({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  bool get isAuthenticated => _auth.currentUser != null;

  @override
  Future<UserModel?> getCurrentUser() async {
    final user = _auth.currentUser;
    if (user == null) return null;
    return _resolveUserModel(user);
  }

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final user = credential.user;
      if (user == null) {
        throw Exception('Sign-in succeeded but user details could not be retrieved.');
      }

      final userModel = await _resolveUserModel(user);

      // Enforce server-side role check:
      // Authenticated accounts without administrator roles must not access the CMS.
      if (!userModel.isAdmin) {
        await _auth.signOut();
        throw Exception(
          'Access Denied: Account (${user.email}) does not have administrator privileges.',
        );
      }

      return userModel;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
        case 'wrong-password':
        case 'invalid-credential':
          throw Exception('Invalid email or password.');
        case 'user-disabled':
          throw Exception('This administrator account has been disabled.');
        case 'too-many-requests':
          throw Exception('Too many login attempts. Please try again later.');
        case 'invalid-email':
          throw Exception('Invalid email address format.');
        default:
          throw Exception(e.message ?? 'Authentication error (${e.code}).');
      }
    } catch (e) {
      if (e is Exception) rethrow;
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> logout() async {
    await _auth.signOut();
  }

  /// Resolves user profile and role securely.
  ///
  /// Role resolution precedence:
  /// 1. Firebase Auth Custom Claims (`token.role` or `token.admin`)
  /// 2. Authoritative Firestore document at `/admins/{uid}`
  /// 3. Fallback: non-admin `UserRole.staff` (disallows admin actions)
  Future<UserModel> _resolveUserModel(User user) async {
    UserRole? resolvedRole;

    try {
      // 1. Check Custom Claims in ID token
      final idTokenResult = await user.getIdTokenResult();
      final claims = idTokenResult.claims ?? {};

      if (claims['role'] != null) {
        resolvedRole = UserRole.fromString(claims['role'].toString());
      } else if (claims['admin'] == true || claims['superAdmin'] == true) {
        resolvedRole = UserRole.superAdmin;
      } else if (claims['manager'] == true) {
        resolvedRole = UserRole.manager;
      }
    } catch (_) {
      // Token claim inspection failed; proceed to Firestore check
    }

    // 2. Check authoritative /admins/{uid} Firestore document
    if (resolvedRole == null) {
      try {
        final adminDoc = await _firestore.collection('admins').doc(user.uid).get();
        if (adminDoc.exists && adminDoc.data() != null) {
          final data = adminDoc.data()!;
          final roleString = data['role']?.toString();
          if (roleString != null) {
            resolvedRole = UserRole.fromString(roleString);
          } else if (data['isAdmin'] == true) {
            resolvedRole = UserRole.manager;
          }
        }
      } catch (_) {
        // Doc read failed or collection protected
      }
    }

    final finalRole = resolvedRole ?? UserRole.staff;

    return UserModel(
      id: user.uid,
      name: user.displayName != null && user.displayName!.isNotEmpty
          ? user.displayName!
          : (user.email?.split('@').first ?? 'Admin'),
      email: user.email ?? '',
      role: finalRole,
      avatarUrl: user.photoURL,
    );
  }
}
