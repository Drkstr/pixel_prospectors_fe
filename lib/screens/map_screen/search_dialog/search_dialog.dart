import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../services/dio_service.dart';
import '../../../services/geocoder_service.dart';
import 'search_dialog_state.dart';

final searchDialogStateProvider = StateNotifierProvider<SearchDialogStateNotifier, SearchDialogState>((ref) {
  return SearchDialogStateNotifier(GeocoderService(ref.read(dioServiceProvider)));
});

class SearchDialog extends ConsumerWidget {
  const SearchDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchState = ref.watch(searchDialogStateProvider);
    final addressController = TextEditingController();
    final latitudeController = TextEditingController();
    final longitudeController = TextEditingController();

    return AlertDialog(
      title: const Text('Search'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: addressController,
            decoration: const InputDecoration(labelText: 'Search by address'),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: latitudeController,
                  decoration: const InputDecoration(labelText: 'Latitude'),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: longitudeController,
                  decoration: const InputDecoration(labelText: 'Longitude'),
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (searchState.searchError != null)
            Text(
              searchState.searchError!,
              style: const TextStyle(color: Colors.red),
            ),
          if (searchState.addressSearchResult!= null)
            Text(
              'Found address: ${searchState.address}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (addressController.text.isNotEmpty) {
              ref.read(searchDialogStateProvider.notifier).searchByAddress(addressController.text);
            } else if (latitudeController.text.isNotEmpty && longitudeController.text.isNotEmpty) {
              ref.read(searchDialogStateProvider.notifier).searchByCoordinates(
                double.parse(latitudeController.text),
                double.parse(longitudeController.text),
              );
            }
          },
          child: const Text('Search'),
        ),
      ],
    );
  }
}
