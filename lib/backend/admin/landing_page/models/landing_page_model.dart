class LandingPageModel {
  final String logoText;
  final String logoHighlight;
  final String loginButtonText;

  final String heroTag;
  final String heroTitle;
  final String? heroDescription;
  final String heroButtonText;
  final String? heroDashboardImageBase64;
  final String? heroBackgroundImageBase64;
  final String dashboardTitle;
  final String dashboardSubtitle;

  final String aboutTag;
  final String aboutTitle;
  final String? aboutDescription;
  final String? aboutImage1Base64;
  final String? aboutImage2Base64;
  final String? aboutImage3Base64;
  final String? aboutImage4Base64;

  final String footerText;
  final DateTime? updatedAt;

  const LandingPageModel({
    required this.logoText,
    required this.logoHighlight,
    required this.loginButtonText,
    required this.heroTag,
    required this.heroTitle,
    this.heroDescription,
    required this.heroButtonText,
    this.heroDashboardImageBase64,
    this.heroBackgroundImageBase64,
    required this.dashboardTitle,
    required this.dashboardSubtitle,
    required this.aboutTag,
    required this.aboutTitle,
    this.aboutDescription,
    this.aboutImage1Base64,
    this.aboutImage2Base64,
    this.aboutImage3Base64,
    this.aboutImage4Base64,
    required this.footerText,
    this.updatedAt,
  });

  factory LandingPageModel.fromMap(Map<String, dynamic> map) {
    return LandingPageModel(
      logoText: map['logo_text']?.toString() ?? '',
      logoHighlight: map['logo_highlight']?.toString() ?? '',
      loginButtonText: map['login_button_text']?.toString() ?? '',
      heroTag: map['hero_tag']?.toString() ?? '',
      heroTitle: map['hero_title']?.toString() ?? '',
      heroDescription: map['hero_description']?.toString(),
      heroButtonText: map['hero_button_text']?.toString() ?? '',
      heroDashboardImageBase64: map['hero_dashboard_image_base64']?.toString(),
      heroBackgroundImageBase64: map['hero_background_image_base64']?.toString(),
      dashboardTitle: map['dashboard_title']?.toString() ?? '',
      dashboardSubtitle: map['dashboard_subtitle']?.toString() ?? '',
      aboutTag: map['about_tag']?.toString() ?? '',
      aboutTitle: map['about_title']?.toString() ?? '',
      aboutDescription: map['about_description']?.toString(),
      aboutImage1Base64: map['about_image_1_base64']?.toString(),
      aboutImage2Base64: map['about_image_2_base64']?.toString(),
      aboutImage3Base64: map['about_image_3_base64']?.toString(),
      aboutImage4Base64: map['about_image_4_base64']?.toString(),
      footerText: map['footer_text']?.toString() ?? '',
      updatedAt: map['updated_at'] == null
          ? null
          : DateTime.tryParse(map['updated_at'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'logo_text': logoText,
      'logo_highlight': logoHighlight,
      'login_button_text': loginButtonText,
      'hero_tag': heroTag,
      'hero_title': heroTitle,
      'hero_description': heroDescription,
      'hero_button_text': heroButtonText,
      'hero_dashboard_image_base64': heroDashboardImageBase64,
      'hero_background_image_base64': heroBackgroundImageBase64,
      'dashboard_title': dashboardTitle,
      'dashboard_subtitle': dashboardSubtitle,
      'about_tag': aboutTag,
      'about_title': aboutTitle,
      'about_description': aboutDescription,
      'about_image_1_base64': aboutImage1Base64,
      'about_image_2_base64': aboutImage2Base64,
      'about_image_3_base64': aboutImage3Base64,
      'about_image_4_base64': aboutImage4Base64,
      'footer_text': footerText,
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}