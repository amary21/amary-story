import 'dart:io';

import 'package:amary_story/feature/add/add_provider.dart';
import 'package:amary_story/feature/add/add_state.dart';
import 'package:amary_story/widget/button/button_widget.dart';
import 'package:amary_story/widget/toast/toast_enum.dart';
import 'package:amary_story/widget/toast/toast_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

class AddScreen extends StatefulWidget {
  final Function() onHome;
  final Function() onBack;

  const AddScreen({super.key, required this.onHome, required this.onBack});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  XFile? _image;
  GoogleMapController? _mapController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Story"),
        leading: IconButton(
          onPressed: widget.onBack,
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Consumer<AddProvider>(
        builder: (contex, provider, _) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            switch (provider.state) {
              case AddErrorState(message: var error):
                showToast(context, ToastEnum.error, error);
                break;
              case AddLoadedState(message: var message):
                showToast(context, ToastEnum.success, message);
                widget.onHome();
                break;
              case _:
                break;
            }

            provider.resetToast();
          });

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child:
                        _image == null
                            ? Icon(
                              Icons.image,
                              size: 100,
                              color: Colors.grey[600],
                            )
                            : Image.file(File(_image!.path), fit: BoxFit.cover),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () => _pickImage(ImageSource.gallery),
                        child: Text("Add Image from Gallery"),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  TextField(
                    decoration: InputDecoration(
                      hintText: "Description",
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 4,
                    onChanged: (value) {
                      provider.description = value;
                    },
                  ),
                  SizedBox(height: 10),
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: SizedBox(
                        height: 350,
                        child: Stack(
                          children: [
                            GoogleMap(
                              initialCameraPosition: CameraPosition(
                                target: LatLng(
                                  provider.latitude,
                                  provider.longitude,
                                ),
                                zoom: 18,
                              ),
                              onMapCreated: (controller) async {
                                setState(() {
                                  _mapController = controller;
                                });

                                await provider.addMarker(
                                  provider.latitude,
                                  provider.longitude,
                                );
                              },
                              markers: provider.markers,
                              myLocationButtonEnabled: false,
                              zoomControlsEnabled: false,
                              mapToolbarEnabled: false,
                              myLocationEnabled: true,
                              onLongPress: (LatLng latLng) {
                                _onLongPressGoogleMap(latLng);
                              },
                            ),
                            Positioned(
                              top: 16,
                              left: 16,
                              right: 16,
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 4,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      provider.street,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.black,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    Text(
                                      provider.address,
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: Colors.black,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 16,
                              right: 16,
                              child: FloatingActionButton(
                                child: const Icon(Icons.my_location),
                                onPressed: () {
                                  _onMyLocationButtonPress();
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  ButtonWidget(
                    isLoading: provider.state is AddLoadingState,
                    isEnable: provider.isEnableButton,
                    textButton: "Upload",
                    onTap: () async {
                      await provider.upload();
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final AddProvider provider = context.read<AddProvider>();
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = pickedFile;
        provider.image = File(pickedFile.path);
      });
    }
  }

  void _onMyLocationButtonPress() async {
    final AddProvider provider = context.read<AddProvider>();
    final Location location = Location();
    late bool serviceEnabled;
    late PermissionStatus permissionGranted;
    late LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        debugPrint("Location services is not available");
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        debugPrint("Location permission is denied");
        return;
      }
    }

    locationData = await location.getLocation();
    final latLng = LatLng(locationData.latitude!, locationData.longitude!);

    provider.addMarker(locationData.latitude!, locationData.longitude!);

    _mapController?.animateCamera(CameraUpdate.newLatLng(latLng));
  }

  void _onLongPressGoogleMap(LatLng latLng) async {
    final AddProvider provider = context.read<AddProvider>();
    provider.addMarker(latLng.latitude, latLng.longitude);

    _mapController?.animateCamera(CameraUpdate.newLatLng(latLng));
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}
