/// Content lifecycle status supporting draft, preview, published, and archived states.
enum ContentStatus {
  draft,
  preview,
  published,
  archived;

  String get label {
    switch (this) {
      case ContentStatus.draft:
        return 'Draft';
      case ContentStatus.preview:
        return 'Preview';
      case ContentStatus.published:
        return 'Published';
      case ContentStatus.archived:
        return 'Archived';
    }
  }

  static ContentStatus fromString(String value) {
    return ContentStatus.values.firstWhere(
      (e) => e.name.toLowerCase() == value.toLowerCase(),
      orElse: () => ContentStatus.draft,
    );
  }
}
