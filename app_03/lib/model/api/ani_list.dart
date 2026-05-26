import 'package:app_03/model/api/title.dart';

class AniList {
  final int id;
  final int idMal;
  final Title title;
  final List<String> synonyms;
  final bool isAdult;

  AniList({
    required this.id,
    required this.idMal,
    required this.title,
    required this.synonyms,
    required this.isAdult,
  });

  factory AniList.fromJson(Map<String, dynamic> json) {
    return AniList(
      id: json['id'],
      idMal: json['idMal'],
      title: Title.fromJson(json['title']),
      synonyms: List<String>.from(json['synonyms']),
      isAdult: json['isAdult'],
    );
  }
}
