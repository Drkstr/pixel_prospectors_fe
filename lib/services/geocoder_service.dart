import 'package:dio/dio.dart';
import '../screens/map_screen/models/address_search_result.dart';
import 'dio_service.dart';

class GeocoderService {
  final DioService dioService;

  GeocoderService(this.dioService);
  static const API_KEY = "key";

  Future<String> getAddressFromCoordinates(double latitude, double longitude) async {
    try {
      final response = await dioService.dio.get(
        'https://maps.googleapis.com/maps/api/geocode/json',
        queryParameters: {
          'latlng': '$latitude,$longitude',
          'key': API_KEY,
        },
      );
      final data = response.data;
      if (data['results'].isNotEmpty) {
        return data['results'][0]['formatted_address'];
      }
      throw Exception('No results found');
    } on DioException catch (e) {
      throw Exception('Failed to get address: ${e.message}');
    }
  }

  Future<List<AddressSearchResult>> searchCoordinatesFromAddress(String address) async {
    print("Calling geocoder $address");
    try {
      final response = await dioService.dio.get(
        'https://maps.googleapis.com/maps/api/geocode/json',
        queryParameters: {
          'address': address,
          'key': API_KEY,
        },
      );
      final data = response.data;
      print(data.toString());
      if (data['results'] != null && data['results'].isNotEmpty) {
        final results = data['results'].take(10).map((result) {
          final location = result['geometry']['location'];
          return AddressSearchResult(
            address: result['formatted_address'],
            latitude: location['lat'],
            longitude: location['lng'],
          );
        }).toList();
        print(results.toString());
        return results;
      }
      return <AddressSearchResult>[];
    } on DioException catch (e) {
      throw Exception('Failed to get search results: ${e.message}');
    }
  }
}
