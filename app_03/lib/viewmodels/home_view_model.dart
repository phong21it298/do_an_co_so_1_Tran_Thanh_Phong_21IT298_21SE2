import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../model/api/anime_response.dart';
import '../services/trace_moe_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:app_03/model/local/search_history.dart';
import 'package:app_03/services/anime_database_helper.dart';

class HomeViewModel extends ChangeNotifier {
  final TraceMoeService _traceMoeService = TraceMoeService();

  Uint8List? _selectedImageBytes;
  String? _imageUrl;
  AnimeResponse? _animeResponse;

  Uint8List? get selectedImageBytes => _selectedImageBytes;
  String? get imageUrl => _imageUrl;
  AnimeResponse? get animeResponse => _animeResponse;

  final ImagePicker _picker = ImagePicker();

  //Chọn ảnh trong thư viện.
  Future<void> pickImageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _selectedImageBytes = await pickedFile.readAsBytes();
      _imageUrl = null;

      _animeResponse = null;
      notifyListeners();

      await searchByImageBytes(_selectedImageBytes!);
    }
  }

  //Tìm kiếm anime qua ảnh byte.
  Future<void> searchByImageBytes(Uint8List imageBytes) async {
    _animeResponse = await _traceMoeService.searchAnimeByImage(imageBytes);
    notifyListeners();
  }

  //Tìm kiếm anime qua link Url.
  Future<void> searchByUrl(String url) async {
    _imageUrl = url;
    _selectedImageBytes = null;

    _animeResponse = null;
    notifyListeners();

    _animeResponse = await _traceMoeService.searchAnimeByUrl(url);
    notifyListeners();
  }

  //Làm mới dữ liệu.
  void clearResult() {
    _animeResponse = null;
    _selectedImageBytes = null;
    _imageUrl = null;
    notifyListeners();
  }

  //Lưu anime tìm kiếm vào lịch sử.
  Future<void> saveToHistory({
    required int userId,
    required String imagePath,
    required String animeTitle,
  }) async {
    final history = SearchHistory(
      userId: userId,
      imagePath: imagePath,
      animeTitle: animeTitle,
      timestamp: DateTime.now(),
    );

    await AnimeDatabaseHelper().insertSearchHistory(history);
  }
}
