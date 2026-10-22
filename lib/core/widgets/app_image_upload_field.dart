import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../data/services/firebase_storage_service.dart';
import '../constants/app_radius.dart';
import '../constants/app_spacing.dart';
import '../theme/app_colors.dart';
import 'app_button.dart';
import 'app_text_field.dart';

class AppImageUploadField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String storageFolder;
  final String? entityId;
  final StorageService? storageService;

  const AppImageUploadField({
    super.key,
    required this.controller,
    required this.label,
    required this.storageFolder,
    this.entityId,
    this.storageService,
  });

  @override
  State<AppImageUploadField> createState() => _AppImageUploadFieldState();
}

class _AppImageUploadFieldState extends State<AppImageUploadField> {
  late final StorageService _storageService;
  final ImagePicker _picker = ImagePicker();

  bool _isUploading = false;
  double _uploadProgress = 0.0;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _storageService = widget.storageService ?? FirebaseStorageService();
  }

  Future<void> _pickAndUploadImage() async {
    setState(() {
      _errorMessage = null;
    });

    try {
      final xFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (xFile == null) return; // User cancelled

      final bytes = await xFile.readAsBytes();
      final fileName = xFile.name.replaceAll(RegExp(r'[^a-zA-Z0-9._-]'), '_');
      final extension = fileName.contains('.') ? fileName.split('.').last.toLowerCase() : 'jpg';

      String mimeType;
      switch (extension) {
        case 'png':
          mimeType = 'image/png';
          break;
        case 'webp':
          mimeType = 'image/webp';
          break;
        case 'jpg':
        case 'jpeg':
        default:
          mimeType = 'image/jpeg';
          break;
      }

      final entityPath = widget.entityId != null && widget.entityId!.isNotEmpty
          ? '${widget.storageFolder}/${widget.entityId}/$fileName'
          : '${widget.storageFolder}/${DateTime.now().millisecondsSinceEpoch}_$fileName';

      setState(() {
        _isUploading = true;
        _uploadProgress = 0.0;
      });

      final oldUrl = widget.controller.text.trim();

      // 1. Upload new image
      final result = await _storageService.uploadImageBytes(
        path: entityPath,
        bytes: bytes,
        contentType: mimeType,
        onProgress: (progress) {
          if (mounted) {
            setState(() => _uploadProgress = progress);
          }
        },
      );

      // 2. Update text controller with download URL
      widget.controller.text = result.downloadUrl;

      // 3. Safe replacement: only remove old file if it was our Firebase storage object
      if (oldUrl.isNotEmpty &&
          oldUrl.contains('firebasestorage.googleapis.com') &&
          oldUrl != result.downloadUrl) {
        await _storageService.deleteFile(oldUrl);
      }

      if (mounted) {
        setState(() {
          _isUploading = false;
          _uploadProgress = 1.0;
        });
      }
    } on StorageValidationException catch (e) {
      if (mounted) {
        setState(() {
          _isUploading = false;
          _errorMessage = e.message;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isUploading = false;
          _errorMessage = 'Upload failed: ${e.toString()}';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasImage = widget.controller.text.trim().isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: AppTextField(
                controller: widget.controller,
                label: widget.label,
                hint: 'https://... or upload from device',
                onChanged: (_) => setState(() {}),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            AppButton(
              text: _isUploading ? '${(_uploadProgress * 100).toInt()}%' : 'Browse',
              icon: Icons.cloud_upload_outlined,
              size: AppButtonSize.md,
              variant: AppButtonVariant.secondary,
              isLoading: _isUploading,
              onPressed: _isUploading ? null : _pickAndUploadImage,
            ),
          ],
        ),
        if (_isUploading) ...[
          const SizedBox(height: AppSpacing.xs),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: _uploadProgress > 0 ? _uploadProgress : null,
              backgroundColor: AppColors.goldMuted.withAlpha(40),
              color: AppColors.goldPrimary,
              minHeight: 4,
            ),
          ),
        ],
        if (_errorMessage != null) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(
            _errorMessage!,
            style: const TextStyle(color: AppColors.error, fontSize: 12),
          ),
        ],
        if (hasImage) ...[
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              ClipRRect(
                borderRadius: AppRadius.borderXs,
                child: Image.network(
                  widget.controller.text.trim(),
                  width: 56,
                  height: 56,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 56,
                    height: 56,
                    color: AppColors.goldMuted.withAlpha(50),
                    child: const Icon(Icons.broken_image_outlined, size: 24),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  'Preview active. Image ready to save.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).textTheme.bodySmall?.color?.withAlpha(180),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.clear, size: 18),
                tooltip: 'Clear image URL',
                onPressed: () {
                  setState(() {
                    widget.controller.clear();
                  });
                },
              ),
            ],
          ),
        ],
      ],
    );
  }
}
