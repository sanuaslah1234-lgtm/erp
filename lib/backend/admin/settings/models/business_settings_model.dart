class BusinessSettingsModel {
  final String? companyLogoBase64;
  final String companyName;
  final String? legalTradeName;
  final String? taxVatNumber;
  final String? officialEmail;
  final String? businessPhone;
  final String? headquartersAddress;
  final DateTime? updatedAt;

  const BusinessSettingsModel({
    this.companyLogoBase64,
    required this.companyName,
    this.legalTradeName,
    this.taxVatNumber,
    this.officialEmail,
    this.businessPhone,
    this.headquartersAddress,
    this.updatedAt,
  });

  factory BusinessSettingsModel.fromMap(Map<String, dynamic> map) {
    return BusinessSettingsModel(
      companyLogoBase64: map['company_logo_base64']?.toString(),
      companyName: map['company_name']?.toString() ?? '',
      legalTradeName: map['legal_trade_name']?.toString(),
      taxVatNumber: map['tax_vat_number']?.toString(),
      officialEmail: map['official_email']?.toString(),
      businessPhone: map['business_phone']?.toString(),
      headquartersAddress: map['headquarters_address']?.toString(),
      updatedAt: map['updated_at'] == null
          ? null
          : DateTime.tryParse(map['updated_at'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'company_logo_base64': companyLogoBase64,
      'company_name': companyName,
      'legal_trade_name': legalTradeName,
      'tax_vat_number': taxVatNumber,
      'official_email': officialEmail,
      'business_phone': businessPhone,
      'headquarters_address': headquartersAddress,
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}