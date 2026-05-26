class SearchHistory {
  final int? id;
  final int userId;
  final String imagePath;
  final String animeTitle;
  final DateTime timestamp;

  SearchHistory({
    this.id,
    required this.userId,
    required this.imagePath,
    required this.animeTitle,
    required this.timestamp,
  });

  //Chuyển từ Map (dữ liệu trong SQLite) sang đối tượng SearchHistory.
  factory SearchHistory.fromMap(Map<String, dynamic> map) {

    //print('fromMap received: $map');

    return SearchHistory(
      id: map['id'],
      userId: map['user_id'],
      imagePath: map['image_path'],
      animeTitle: map['anime_title'],
      timestamp: DateTime.parse(map['timestamp']),
    );
  }

  //Chuyển từ đối tượng SearchHistory sang Map để lưu vào SQLite.
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = {
      'user_id': userId,
      'image_path': imagePath,
      'anime_title': animeTitle,
      'timestamp': timestamp.toIso8601String(),
    };

    if (id != null) {
      map['id'] = id;
    }

    return map;
  }
}
