class AddressSearchResult {
  final String address;
  final double latitude;
  final double longitude;

  AddressSearchResult({
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  factory AddressSearchResult.fromJson(Map<String, dynamic> json) {
    return AddressSearchResult(
      address: json['formatted_address'],
      latitude: json['geometry']['location']['lat'],
      longitude: json['geometry']['location']['lng'],
    );
  }
}
