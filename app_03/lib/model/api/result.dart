import 'package:app_03/model/api/ani_list.dart';

class Result {
  final AniList anilist;
  final int? episode;
  final double from;
  final double to;
  final double similarity;
  final String video;
  final String image;

  Result({
    required this.anilist,
    required this.episode,
    required this.from,
    required this.to,
    required this.similarity,
    required this.video,
    required this.image,
  });

  factory Result.fromJson(Map<String, dynamic> json) {
    return Result(
      anilist: AniList.fromJson(json['anilist']),
      episode: json['episode'] != null ? json['episode'] as int : null,
      from: (json['from'] as num).toDouble(),
      to: (json['to'] as num).toDouble(),
      similarity: (json['similarity'] as num).toDouble(),
      video: json['video'],
      image: json['image'],
    );
  }
}
