import 'package:amary_story/feature/detail/detail_provider.dart';
import 'package:amary_story/feature/detail/detail_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetailScreen extends StatefulWidget {
  final String id;

  const DetailScreen({super.key, required this.id});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
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
      ),
      body: Consumer<DetailProvider>(
        builder: (context, provider, _) {
          return switch (provider.state) {
            DetailLoadedState(story: var story) => SingleChildScrollView(
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
                      crossAxisAlignment: CrossAxisAlignment.center,
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
                        )
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
            DetailLoadingState() => const Center(
              child: CircularProgressIndicator(),
            ),
            DetailErrorState(message: var message) => Center(
              child: Text(message),
            ),
            _ => SizedBox(),
          };
        },
      ),
    );
  }
}
