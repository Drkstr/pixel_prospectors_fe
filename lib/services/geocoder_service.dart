import 'package:dio/dio.dart';
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

  Future<Map<String, double>> getCoordinatesFromAddress(String address) async {
    try {
      final response = await dioService.dio.get(
        'https://maps.googleapis.com/maps/api/geocode/json',
        queryParameters: {
          'address': address,
          'key': API_KEY,
        },
      );
      final data = response.data;
      if (data['results'].isNotEmpty) {
        final location = data['results'][0]['geometry']['location'];
        return {
          'latitude': location['lat'],
          'longitude': location['lng'],
        };
      }
      throw Exception('No results found');
    } on DioException catch (e) {
      throw Exception('Failed to get coordinates: ${e.message}');
    }
  }
}
