class Title {
  final String native;
  final String? romaji;
  final String? english;

  Title({
    required this.native,
    this.romaji,
    this.english,
  });

  factory Title.fromJson(Map<String, dynamic> json) {
    return Title(
      native: json['native'] ?? '',
      romaji: json['romaji'] ?? '',
      english: json['english'],
    );
  }
}
