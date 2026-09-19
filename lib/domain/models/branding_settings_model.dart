/// Dynamic Branding, Salon Identity & Social Media Settings.
class BrandingSettingsModel {
  final String brandName;
  final String tagline;
  final String logoUrl;
  final String instagramUrl;
  final String facebookUrl;
  final String youtubeUrl;
  final String pinterestUrl;
  final String metaDescription;
  final String currencySymbol;

  const BrandingSettingsModel({
    required this.brandName,
    required this.tagline,
    required this.logoUrl,
    required this.instagramUrl,
    required this.facebookUrl,
    required this.youtubeUrl,
    required this.pinterestUrl,
    required this.metaDescription,
    this.currencySymbol = '₹',
  });

  BrandingSettingsModel copyWith({
    String? brandName,
    String? tagline,
    String? logoUrl,
    String? instagramUrl,
    String? facebookUrl,
    String? youtubeUrl,
    String? pinterestUrl,
    String? metaDescription,
    String? currencySymbol,
  }) {
    return BrandingSettingsModel(
      brandName: brandName ?? this.brandName,
      tagline: tagline ?? this.tagline,
      logoUrl: logoUrl ?? this.logoUrl,
      instagramUrl: instagramUrl ?? this.instagramUrl,
      facebookUrl: facebookUrl ?? this.facebookUrl,
      youtubeUrl: youtubeUrl ?? this.youtubeUrl,
      pinterestUrl: pinterestUrl ?? this.pinterestUrl,
      metaDescription: metaDescription ?? this.metaDescription,
      currencySymbol: currencySymbol ?? this.currencySymbol,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'brandName': brandName,
      'tagline': tagline,
      'logoUrl': logoUrl,
      'instagramUrl': instagramUrl,
      'facebookUrl': facebookUrl,
      'youtubeUrl': youtubeUrl,
      'pinterestUrl': pinterestUrl,
      'metaDescription': metaDescription,
      'currencySymbol': currencySymbol,
    };
  }

  factory BrandingSettingsModel.fromJson(Map<String, dynamic> json) {
    return BrandingSettingsModel(
      brandName: json['brandName'] as String,
      tagline: json['tagline'] as String,
      logoUrl: json['logoUrl'] as String,
      instagramUrl: json['instagramUrl'] as String,
      facebookUrl: json['facebookUrl'] as String,
      youtubeUrl: json['youtubeUrl'] as String,
      pinterestUrl: json['pinterestUrl'] as String,
      metaDescription: json['metaDescription'] as String,
      currencySymbol: json['currencySymbol'] as String? ?? '₹',
    );
  }
}
