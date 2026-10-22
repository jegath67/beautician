import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';

class StorageUploadResult {
  final String downloadUrl;
  final String storagePath;
  final int sizeBytes;

  const StorageUploadResult({
    required this.downloadUrl,
    required this.storagePath,
    required this.sizeBytes,
  });
}

class StorageValidationException implements Exception {
  final String message;
  const StorageValidationException(this.message);

  @override
  String toString() => message;
}

abstract class StorageService {
  Future<StorageUploadResult> uploadImageBytes({
    required String path,
    required Uint8List bytes,
    required String contentType,
    void Function(double progress)? onProgress,
  });

  Future<void> deleteFile(String pathOrUrl);
}

class FirebaseStorageService implements StorageService {
  final FirebaseStorage? _customStorage;

  FirebaseStorageService({FirebaseStorage? storage})
      : _customStorage = storage;

  FirebaseStorage get _storage => _customStorage ?? FirebaseStorage.instance;

  static const int maxFileSize = 5 * 1024 * 1024; // 5 MB
  static const List<String> allowedMimeTypes = [
    'image/jpeg',
    'image/png',
    'image/webp',
  ];

  @override
  Future<StorageUploadResult> uploadImageBytes({
    required String path,
    required Uint8List bytes,
    required String contentType,
    void Function(double progress)? onProgress,
  }) async {
    // 1. Validate file size
    if (bytes.isEmpty) {
      throw const StorageValidationException('File is empty.');
    }
    if (bytes.length > maxFileSize) {
      throw const StorageValidationException(
        'Image exceeds the maximum allowed size of 5 MB.',
      );
    }

    // 2. Validate MIME type
    final normalizedMime = contentType.toLowerCase().trim();
    if (!allowedMimeTypes.contains(normalizedMime)) {
      throw StorageValidationException(
        'Invalid file type ($contentType). Only JPEG, PNG, and WebP are allowed.',
      );
    }

    // 3. Prepare metadata and reference
    final ref = _storage.ref(path);
    final metadata = SettableMetadata(
      contentType: normalizedMime,
      customMetadata: {'uploadedAt': DateTime.now().toIso8601String()},
    );

    final uploadTask = ref.putData(bytes, metadata);

    // 4. Track progress if callback provided
    if (onProgress != null) {
      uploadTask.snapshotEvents.listen((event) {
        if (event.totalBytes > 0) {
          final progress = event.bytesTransferred / event.totalBytes;
          onProgress(progress.clamp(0.0, 1.0));
        }
      });
    }

    final snapshot = await uploadTask;
    final downloadUrl = await snapshot.ref.getDownloadURL();

    return StorageUploadResult(
      downloadUrl: downloadUrl,
      storagePath: path,
      sizeBytes: bytes.length,
    );
  }

  @override
  Future<void> deleteFile(String pathOrUrl) async {
    try {
      Reference ref;
      if (pathOrUrl.startsWith('gs://') || pathOrUrl.startsWith('http')) {
        ref = _storage.refFromURL(pathOrUrl);
      } else {
        ref = _storage.ref(pathOrUrl);
      }
      await ref.delete();
    } catch (_) {
      // Gracefully swallow delete failure so replacement workflows are not interrupted
    }
  }
}
