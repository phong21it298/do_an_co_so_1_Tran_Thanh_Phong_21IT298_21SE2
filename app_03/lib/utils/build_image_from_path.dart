import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';

class BuildImageFromPath extends StatelessWidget {
  final String imagePath;

  const BuildImageFromPath({required this.imagePath, super.key});

  @override
  Widget build(BuildContext context) {
    if (imagePath.startsWith("http")) {
      return Image.network(imagePath, fit: BoxFit.cover);
    } else if (File(imagePath).existsSync()) {
      return Image.file(File(imagePath), fit: BoxFit.cover);
    } else {
      try {
        final bytes = base64Decode(imagePath);
        return Image.memory(bytes, fit: BoxFit.cover);
      } catch (_) {
        return const Icon(Icons.broken_image);
      }
    }
  }
}
