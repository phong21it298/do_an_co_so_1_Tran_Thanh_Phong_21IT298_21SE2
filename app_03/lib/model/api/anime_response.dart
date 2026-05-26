import 'package:app_03/model/api/result.dart';

class AnimeResponse {
  final int frameCount;
  final String error;
  final List<Result> result;

  AnimeResponse({
    required this.frameCount,
    required this.error,
    required this.result,
  });

  //Tạo đối tượng AnimeResponse từ dữ liệu JSON.
  factory AnimeResponse.fromJson(Map<String, dynamic> json) {
    return AnimeResponse(
      frameCount: json['frameCount'],
      error: json['error'],
      result: (json['result'] as List)
          .map((item) => Result.fromJson(item))
          .toList(),
    );
  }
}
