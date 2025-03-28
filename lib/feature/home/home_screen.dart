import 'package:amary_story/feature/home/home_provider.dart';
import 'package:amary_story/feature/home/home_state.dart';
import 'package:amary_story/widget/toast/toast_enum.dart';
import 'package:amary_story/widget/toast/toast_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  final Function(String) onDetail;
  final Function onAddStory;
  final Function onLogout;

  const HomeScreen({
    super.key,
    required this.onDetail,
    required this.onAddStory,
    required this.onLogout,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    final HomeProvider provider = context.read<HomeProvider>();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        final state = provider.state;
        if (state is HomeLoadedState && state.hasMore) {
          provider.fetchStories(isLoadMore: true);
        }
      }
    });

    Future.microtask(() {
      provider.init();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
          IconButton(
            icon: Icon(Icons.add_box_outlined),
            onPressed: () {
              widget.onAddStory();
            },
          ),
        ],
      ),
      body: Consumer<HomeProvider>(
        builder: (_, provider, _) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (provider.isLogout) {
              showToast(context, ToastEnum.success, "Anda berhasil logout");
              widget.onLogout();
            }
          });
          final state = provider.state;

          if (state is HomeLoadingState) {
            return Center(child: CircularProgressIndicator());
          } else if (state is HomeErrorState) {
            return Center(child: Text(state.message));
          } else if (state is HomeLoadedState) {
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: state.stories.length + (state.hasMore ? 1 : 0),
                    controller: _scrollController,
                    itemBuilder: (context, index) {
                      if (index == state.stories.length) {
                        return Center(child: CircularProgressIndicator());
                      }
                      final story = state.stories[index];
                      return GestureDetector(
                        onTap: () {
                          widget.onDetail(story.id);
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
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }
          return SizedBox();
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
                Navigator.pop(context);
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
