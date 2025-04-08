import 'dart:io';

import 'package:amary_story/data/api/repository/story_repository.dart';
import 'package:amary_story/feature/add/add_state.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart' as geo;

class AddProvider extends ChangeNotifier {
  final StoryRepository _repository;

  AddProvider({required StoryRepository repository}) : _repository = repository;

  String _description = "";
  String get description => _description;

  File? _image;

  bool _isEnableButton = false;
  bool get isEnableButton => _isEnableButton;

  AddState _state = AddNoneState();
  AddState get state => _state;

  Set<Marker> markers = {};
  String address = "";
  String street = "";
  double latitude = -6.175372; // Default to Jakarta
  double longitude = 106.827194; // Default to Jakarta

  set description(String value) {
    _description = value;
    notifyListeners();

    _checkButton();
  }

  set image(File value) {
    _image = value;
    notifyListeners();

    _checkButton();
  }

  void _checkButton() {
    if (_description.isNotEmpty && _image != null) {
      _isEnableButton = true;
    } else {
      _isEnableButton = false;
    }
    notifyListeners();
  }

  Future<void> upload() async {
    try {
      _state = AddLoadingState();
      notifyListeners();

      final result = await _repository.addStory(description, _image!, lat: latitude, lon: longitude);
      _state = AddLoadedState(message: result);
      notifyListeners();
    } catch (e) {
      _state = AddErrorState(message: e.toString());
      notifyListeners();
    }
  }

  Future<void> addMarker(double lat, double lon) async {
    try {
      final placemarks = await geo.placemarkFromCoordinates(lat, lon);
      final place = placemarks.isNotEmpty ? placemarks.first : null;
      final street = place?.street ?? "Tidak diketahui";
      final address =
          '${place?.subLocality}, ${place?.locality}, ${place?.postalCode}, ${place?.country}';
      this.address = address;
      this.street = street;
    } catch (e) {
      debugPrint("Error fetching address: $e");
    }
    latitude = lat;
    longitude = lon;
    markers.clear();
    markers.add(
      Marker(
        markerId: const MarkerId('storyLocation'),
        position: LatLng(lat, lon),
        infoWindow: InfoWindow(title: street, snippet: address),
      )
    );
    notifyListeners();
  }

  void resetToast() {
    _state = AddNoneState();
    notifyListeners();
  }
}
