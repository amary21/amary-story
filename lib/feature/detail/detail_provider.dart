import 'package:amary_story/data/api/repository/story_repository.dart';
import 'package:amary_story/feature/detail/detail_state.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DetailProvider extends ChangeNotifier {
  final StoryRepository _repository;

  DetailProvider({required StoryRepository repository})
    : _repository = repository;

  DetailState _state = DetailNoneState();
  DetailState get state => _state;

  Set<Marker> markers = {};
  String address = "";
  String street = "";

  Future<void> getDetail(String id) async {
    try {
      _state = DetailLoadingState();
      notifyListeners();

      final result = await _repository.fetchStoryDetail(id);
      _state = DetailLoadedState(story: result);
      _loadLocation(result.lat, result.lon);
      notifyListeners();
    } catch (e) {
      _state = DetailErrorState(message: e.toString());
      notifyListeners();
    }
  }

  Future<void> _loadLocation(double? lat, double? lon) async {
    try {
      if (lat == null || lon == null) {
        return;
      }

      final placemarks = await geo.placemarkFromCoordinates(lat, lon);
      final place = placemarks.isNotEmpty ? placemarks.first : null;

      if (place != null) {
        final street = place.street ?? "Tidak diketahui";
        final address =
            '${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
        this.address = address;
        this.street = street;
        markers = {
          Marker(
            markerId: const MarkerId('storyLocation'),
            position: LatLng(lat, lon),
            infoWindow: InfoWindow(title: street, snippet: address),
          ),
        };
      }

      notifyListeners();
    } catch (e) {
      debugPrint("Error fetching address: $e");
    }
  }
}
