class Industry {
  final String name;
  final String slug;

  const Industry({required this.name, required this.slug});
}

class Company {
  final String id;
  final String name;
  final String locationText;
  final String phone;
  final String status;
  final String industryName;
  final String industrySlug;
  final double lat;
  final double lng;

  const Company({
    required this.id,
    required this.name,
    required this.locationText,
    required this.phone,
    required this.status,
    required this.industryName,
    required this.industrySlug,
    required this.lat,
    required this.lng,
  });
}
