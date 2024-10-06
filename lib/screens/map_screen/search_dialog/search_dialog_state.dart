import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pixelprospectors_fe/screens/map_screen/models/address_search_result.dart';
import '../../../services/geocoder_service.dart';

class SearchDialogState {
  final double latitude;
  final double longitude;
  final String address;
  final List<AddressSearchResult>? addressSearchResult;
  final String? searchError;

  SearchDialogState({
    required this.latitude,
    required this.longitude,
    required this.address,
    this.searchError,
    this.addressSearchResult
  });

  SearchDialogState copyWith({
    double? latitude,
    double? longitude,
    String? address,
    List<AddressSearchResult>? addressSearchResult,
    String? searchError,
  }) {
    return SearchDialogState(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      address: address ?? this.address,
      addressSearchResult: addressSearchResult ?? this.addressSearchResult,
      searchError: searchError ?? this.searchError,
    );
  }
}

class SearchDialogStateNotifier extends StateNotifier<SearchDialogState> {
  final GeocoderService geocoderService;

  SearchDialogStateNotifier(this.geocoderService) : super(SearchDialogState(latitude: 0, longitude: 0, addressSearchResult: [], searchError: null, address: ''));
  void updateLocation(double latitude, double longitude) {
    state = SearchDialogState(latitude: latitude, longitude: longitude, address: state.address);
  }

  void updateAddress(String address) {
    state = SearchDialogState(latitude: state.latitude, longitude: state.longitude, address: address);
  }

  Future<void> searchByAddress(String address) async {
    try {
      final searchResult = await geocoderService.searchCoordinatesFromAddress(address);
      if(searchResult.isNotEmpty){
        state.copyWith(addressSearchResult: searchResult);
      }else{
        setSearchError('Error searching by address: Address not found');
      }
    } catch (e) {
      setSearchError('Error searching by address: $e');
    }
  }

  Future<void> searchByCoordinates(double latitude, double longitude) async {
    try {
      final address = await geocoderService.getAddressFromCoordinates(latitude, longitude);
      state = SearchDialogState(
          latitude: latitude,
          longitude: longitude,
          address: address
      );
    } catch (e) {
      setSearchError('Error searching by coordinates: $e');
    }
  }

  void setSearchError(String? error) {
    state = SearchDialogState(latitude: state.latitude, longitude: state.longitude, address: state.address, searchError: error);
  }
}
