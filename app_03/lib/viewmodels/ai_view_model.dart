import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../services/ai_generation_service.dart';

class AiViewModel extends ChangeNotifier {
  final AiGenerationService _aiService = AiGenerationService();

  Uint8List? _generatedImage;
  bool _isLoading = false;

  Uint8List? get generatedImage => _generatedImage;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<void> generateImage(String prompt) async {

    if (prompt.isEmpty) return;

    _isLoading = true;
    _generatedImage = null;
    _errorMessage = null;

    notifyListeners();  //Để hiện loading.

    _generatedImage = await _aiService.generateAnimeImage(prompt);

    if (_generatedImage == null) {

      _errorMessage = "Không thể sinh ảnh. Vui lòng thử lại!";
    }

    _isLoading = false;

    notifyListeners();  //Để hiện ảnh/error.
  }

  void clear() {

    _generatedImage = null;

    notifyListeners();
  }
}