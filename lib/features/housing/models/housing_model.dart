class HousingModel {
  final int propertyId;
  final String name;
  final String address;
  final String city;
  final String state;
  final String zipCode;
  final double distanceMiles;
  final String priceSummary;
  final Map<String, dynamic> floorPlanSummary;
  final String phoneNumber;
  final String? imageUrl;

  HousingModel({
    required this.propertyId,
    required this.name,
    required this.address,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.distanceMiles,
    required this.priceSummary,
    required this.floorPlanSummary,
    required this.phoneNumber,
    this.imageUrl,
  });

  factory HousingModel.fromJson(Map<String, dynamic> json) {
    return HousingModel(
      propertyId: json['property_id'] ?? 0,
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      zipCode: json['zip_code'] ?? '',
      distanceMiles: (json['distance_miles'] ?? 0).toDouble(),
      priceSummary: json['price_summary'] ?? '',
      floorPlanSummary: json['floor_plan_summary'] ?? {},
      phoneNumber: json['phone_number'] ?? '',
      imageUrl: json['image_url'],
    );
  }
}
