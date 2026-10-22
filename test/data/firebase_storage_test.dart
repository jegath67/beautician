import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:beautician/data/services/firebase_storage_service.dart';

void main() {
  group('StorageService Validation Tests', () {
    test('Throws StorageValidationException when bytes are empty', () async {
      final service = FirebaseStorageService();
      expect(
        () => service.uploadImageBytes(
          path: 'services/test/img.png',
          bytes: Uint8List(0),
          contentType: 'image/png',
        ),
        throwsA(isA<StorageValidationException>()),
      );
    });

    test('Throws StorageValidationException when file exceeds 5MB', () async {
      final service = FirebaseStorageService();
      final oversizedBytes = Uint8List(5 * 1024 * 1024 + 10);
      expect(
        () => service.uploadImageBytes(
          path: 'services/test/large.png',
          bytes: oversizedBytes,
          contentType: 'image/png',
        ),
        throwsA(isA<StorageValidationException>()),
      );
    });

    test('Throws StorageValidationException for invalid MIME types', () async {
      final service = FirebaseStorageService();
      final validBytes = Uint8List.fromList([1, 2, 3, 4]);
      expect(
        () => service.uploadImageBytes(
          path: 'services/test/doc.pdf',
          bytes: validBytes,
          contentType: 'application/pdf',
        ),
        throwsA(isA<StorageValidationException>()),
      );
    });
  });
}
