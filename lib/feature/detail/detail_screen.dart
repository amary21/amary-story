import 'package:amary_story/feature/detail/detail_provider.dart';
import 'package:amary_story/feature/detail/detail_state.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class DetailScreen extends StatefulWidget {
  final String id;
  final Function() onBack;

  const DetailScreen({super.key, required this.id, required this.onBack});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  GoogleMapController? _mapController;

  @override
  void initState() {
    final DetailProvider provider = context.read<DetailProvider>();
    Future.microtask(() {
      provider.getDetail(widget.id);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail Story"),
        leading: IconButton(
          onPressed: widget.onBack,
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Consumer<DetailProvider>(
        builder: (context, provider, _) {
          switch (provider.state) {
            case DetailLoadedState(:var story):
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Gambar
                    Image.network(
                      story.photoUrl,
                      width: double.infinity,
                      height: 250,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 16),

                    // Nama & Tanggal
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          Icon(Icons.person, size: 24, color: Colors.blueGrey),
                          const SizedBox(width: 8),
                          Text(
                            story.name,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 4.0,
                      ),
                      child: Text(
                        "Dibuat pada: ${story.createdAt}",
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Deskripsi
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        story.description,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Lokasi
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          Icon(Icons.location_on, color: Colors.red),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Lat: ${story.lat}",
                                style: TextStyle(fontSize: 14),
                              ),
                              Text(
                                "Lon: ${story.lon}",
                                style: TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    if (story.lat != null && story.lon != null)
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: SizedBox(
                              height: 250,
                              child: Stack(
                                children: [
                                  GoogleMap(
                                    initialCameraPosition: CameraPosition(
                                      target: LatLng(story.lat!, story.lon!),
                                      zoom: 18,
                                    ),
                                    onMapCreated: (controller) {
                                      _mapController = controller;
                                    },
                                    markers: provider.markers,
                                    myLocationButtonEnabled: false,
                                    zoomControlsEnabled: false,
                                    mapToolbarEnabled: false,
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
                                            style: const TextStyle(fontSize: 12, color: Colors.black),
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            provider.address,
                                            style: const TextStyle(fontSize: 10, color: Colors.black),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                    const SizedBox(height: 20),
                  ],
                ),
              );

            case DetailLoadingState():
              return const Center(child: CircularProgressIndicator());

            case DetailErrorState(:var message):
              return Center(child: Text(message));

            default:
              return const SizedBox();
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}
