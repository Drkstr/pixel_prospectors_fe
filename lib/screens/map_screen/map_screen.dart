import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../services/dio_service.dart';
import '../../services/geocoder_service.dart';
import 'map_screen_state.dart';

final mapStateProvider = StateNotifierProvider<MapStateNotifier, MapState>(
    (ref) => MapStateNotifier(
      GeocoderService(ref.read(dioServiceProvider))
    ));

class MapScreen extends ConsumerWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapState = ref.watch(mapStateProvider);
    final addressController = TextEditingController();
    final latitudeController = TextEditingController();
    final longitudeController = TextEditingController();
    final searchError = mapState.searchError;
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(mapState.latitude, mapState.longitude),
              zoom: 3,
            ),
            onMapCreated: (controller) {
              // Initialize map controller if needed
            },
            onCameraMove: (CameraPosition position) {
              ref.read(mapStateProvider.notifier).updateLocation(
                    position.target.latitude,
                    position.target.longitude,
                  );
            },
          ),
          Positioned(
            top: 50,
            left: 20,
            right: 20,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: addressController,
                          decoration: const InputDecoration(
                            hintText: 'Search by address',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => ref
                            .read(mapStateProvider.notifier)
                            .searchByAddress(addressController.text),
                        child: const Text('Search'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: latitudeController,
                          decoration: const InputDecoration(
                              hintText: 'Latitude', border: InputBorder.none),
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          controller: longitudeController,
                          decoration: const InputDecoration(
                              hintText: 'Longitude', border: InputBorder.none),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => ref
                            .read(mapStateProvider.notifier)
                            .searchByCoordinates(
                              double.parse(latitudeController.text),
                              double.parse(longitudeController.text),
                            ),
                        child: const Text('Search'),
                      ),
                    ],
                  ),
                ),
                if (searchError != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                        searchError, style: const TextStyle(color: Colors.red)),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
