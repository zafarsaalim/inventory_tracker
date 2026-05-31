class LicenseModel {
  final String key;
  final String expires;
  final String status;

  LicenseModel({
    required this.key,
    required this.expires,
    required this.status,
  });

  factory LicenseModel.fromJson(Map<String, dynamic> json) {
    return LicenseModel(
      key: json['key'] ?? '',
      expires: json['expires'] ?? '',
      status: json['status'] ?? '',
    );
  }
}
