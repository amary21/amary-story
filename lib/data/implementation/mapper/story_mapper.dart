import 'package:amary_story/data/api/model/story.dart';
import 'package:amary_story/data/implementation/remote/response/story_response.dart';
import 'package:intl/intl.dart';

extension StoryMapper on StoryResponse {
  Story toStory() {
    return Story(
      id: id,
      name: name,
      description: description,
      photoUrl: photoUrl,
      createdAt: _formatDateTime(createdAt),
      lat: lat,
      lon: lon,
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('dd MMM yyyy, HH:mm').format(dateTime);
  }
}
