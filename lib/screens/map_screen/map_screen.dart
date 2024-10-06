import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../services/dio_service.dart';
import '../../services/geocoder_service.dart';
import 'map_screen_state.dart';
import 'models/address_search_result.dart';
import 'search_dialog/search_dialog.dart';

final mapStateProvider = StateNotifierProvider<MapStateNotifier, MapState>(
    (ref) => MapStateNotifier(
      GeocoderService(ref.read(dioServiceProvider))
    ));

class MapScreen extends ConsumerWidget {
  const MapScreen({super.key});

  void _showSearchDialog(BuildContext context, WidgetRef ref) async {
    final result = await showDialog<AddressSearchResult>(
      context: context,
      builder: (context) => const SearchDialog(),
    );
    if (result != null) {
      ref.read(mapStateProvider.notifier).updateLocation(result.latitude, result.longitude);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mapState = ref.watch(mapStateProvider);
    return Scaffold(
      appBar: AppBar(
        // title: const Text('Map'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _showSearchDialog(context, ref),
          ),
          DropdownButton<String>(
            value: 'English',
            items: ['English', 'Spanish', 'French'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              // Handle language change
            },
          )
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(0, 0),
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
        ],
      ),
    );
  }
}
