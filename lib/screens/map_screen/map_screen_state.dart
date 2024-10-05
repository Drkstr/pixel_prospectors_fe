import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:geocoding/geocoding.dart';

class MapState {
  final double latitude;
  final double longitude;
  final String address;
  final String? searchError;

  MapState({
    required this.latitude,
    required this.longitude,
    required this.address,
    this.searchError,
  });
}

class MapStateNotifier extends StateNotifier<MapState> {
  MapStateNotifier() : super(MapState(latitude: 0, longitude: 0, address: '', searchError: null));

  void updateLocation(double latitude, double longitude) {
    state = MapState(latitude: latitude, longitude: longitude, address: state.address);
  }

  void updateAddress(String address) {
    state = MapState(latitude: state.latitude, longitude: state.longitude, address: address);
  }

  Future<void> searchByAddress(String address) async {
    try {
      // final locations = await locationFromAddress(address);
      // if (locations.isNotEmpty) {
      //   state = MapState(latitude: locations.first.latitude, longitude: locations.first.longitude, address: address);
      // }
      print(address);
    } catch (e) {
      setSearchError('Error searching by address: $e');
    }
  }

  Future<void> searchByCoordinates(double latitude, double longitude) async {
    try {
      // final placeMarks = await placemarkFromCoordinates(latitude, longitude);
      // if (placeMarks.isNotEmpty) {
      //   final address = '${placeMarks.first.street}, ${placeMarks.first.locality}, ${placeMarks.first.country}';
      //   state = MapState(latitude: latitude, longitude: longitude, address: address);
      // }
      print("$latitude, $longitude");
    } catch (e) {
      setSearchError('Error searching by coordinates: $e');
    }
  }

  void setSearchError(String? error) {
    state = MapState(latitude: state.latitude, longitude: state.longitude, address: state.address, searchError: error);
  }
}
