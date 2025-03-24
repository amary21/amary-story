import 'package:amary_story/feature/home/home_provider.dart';
import 'package:amary_story/feature/home/home_state.dart';
import 'package:amary_story/route/nav_route.dart';
import 'package:amary_story/widget/toast/toast_enum.dart';
import 'package:amary_story/widget/toast/toast_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    final HomeProvider provider = context.read<HomeProvider>();
    Future.microtask(() {
      provider.init();
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Align(
          alignment: Alignment.centerLeft,
          child: GestureDetector(
            onTap: () {
              _showInfoDialog(context);
            },
            child: Row(
              children: [
                Icon(Icons.person, size: 24),
                SizedBox(width: 8),
                Text(
                  context.watch<HomeProvider>().name,
                  style: TextStyle(fontFamily: 'Billabong', fontSize: 20),
                ),
              ],
            ),
          ),
        ),
        actions: [
          IconButton(icon: Icon(Icons.add_box_outlined), onPressed: () {
            Navigator.pushNamed(context, NavRoute.addRoute.name);
          }),
        ],
      ),
      body: Consumer<HomeProvider>(
        builder: (_, provider, _) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (provider.isLogout) {
              showToast(context, ToastEnum.success, "Anda berhasil logout");
              Navigator.pushNamed(context, NavRoute.mainRoute.name);
            }
          });

          return switch (provider.state) {
            HomeLoadedState(stories: var stories) => Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: stories.length,
                    itemBuilder: (context, index) {
                      final story = stories[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            NavRoute.detailRoute.name,
                            arguments: story.id,
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              leading: Icon(Icons.person, size: 24),
                              title: Text(story.name),
                              subtitle: Text(story.createdAt),
                            ),
                            Image.network(
                              story.photoUrl,
                              fit: BoxFit.cover,
                              height: 250,
                              width: double.infinity,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                                vertical: 8.0,
                              ),
                              child: Text(
                                story.description,
                                style: TextStyle(fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            HomeLoadingState() => const Center(
              child: CircularProgressIndicator(),
            ),
            HomeErrorState(message: var message) => Center(
              child: Text(message),
            ),
            _ => SizedBox(),
          };
        },
      ),
    );
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Konfirmasi Logout"),
          content: Text("Apakah Anda yakin ingin logout?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Batal"),
            ),
            TextButton(
              onPressed: () async {
                await context.read<HomeProvider>().logout();
              },
              child: Text("Logout", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
