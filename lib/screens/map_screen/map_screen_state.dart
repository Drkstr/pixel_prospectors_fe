import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/geocoder_service.dart';
import 'models/address_search_result.dart';
class MapState {
  final double latitude;
  final double longitude;
  final String address;
  final List<AddressSearchResult>? addressSearchResult;
  final String? searchError;

  MapState({
    required this.latitude,
    required this.longitude,
    required this.address,
    this.addressSearchResult,
    this.searchError,
  });

  MapState copyWith({
    double? latitude,
    double? longitude,
    String? address,
    List<AddressSearchResult>? addressSearchResult,
    String? searchError,
  }) {
    return MapState(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      addressSearchResult: addressSearchResult ?? this.addressSearchResult,
      searchError: searchError ?? this.searchError,
    );
  }
}

class MapStateNotifier extends StateNotifier<MapState> {
  final GeocoderService geocoderService;

  MapStateNotifier(this.geocoderService) : super(MapState(latitude: 0, longitude: 0, address: '', searchError: null));

  void updateLocation(double latitude, double longitude) {
    state = MapState(latitude: latitude, longitude: longitude, address: state.address);
  }

  void updateAddress(String address) {
    state = MapState(latitude: state.latitude, longitude: state.longitude, address: address);
  }

  // Future<void> searchByAddress(String address) async {
  //   try {
  //     final coordinates = await geocoderService.searchCoordinatesFromAddress(address);
  //     state = MapState(
  //       latitude: coordinates['latitude']!,
  //       longitude: coordinates['longitude']!,
  //       address: address
  //     );
  //   } catch (e) {
  //     setSearchError('Error searching by address: $e');
  //   }
  // }

  Future<void> searchByCoordinates(double latitude, double longitude) async {
    try {
      final address = await geocoderService.getAddressFromCoordinates(latitude, longitude);
      state = MapState(
        latitude: latitude,
        longitude: longitude,
        address: address
      );
    } catch (e) {
      setSearchError('Error searching by coordinates: $e');
    }
  }

  void setSearchError(String? error) {
    state = MapState(latitude: state.latitude, longitude: state.longitude, address: state.address, searchError: error);
  }
}
