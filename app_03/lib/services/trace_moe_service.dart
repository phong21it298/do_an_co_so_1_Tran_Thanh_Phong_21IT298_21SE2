import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import '../model/api/anime_response.dart';

class TraceMoeService {

  //Tìm kiếm theo ảnh trong thư viện điện thoại (offline).
  Future<AnimeResponse?> searchAnimeByImage(Uint8List imageBytes) async {
    final uri = Uri.parse(
      'https://api.trace.moe/search?cutBorders&anilistInfo',
    );

    final request = http.MultipartRequest('POST', uri);

    request.files.add(
      http.MultipartFile.fromBytes(
        'image', //header.
        imageBytes, //data.
        filename: 'image.jpg', //Chỉ giả lập tên file. Gửi ảnh định dạng gì cũng được.
      ),
    );

    final response = await request.send();
    if (response.statusCode == 200) {
      final responseData = await response.stream.bytesToString();
      return AnimeResponse.fromJson(json.decode(responseData));
    } else {
      print('Lỗi truy vấn API: ${response.statusCode}');
      return null;
    }
  }

  //Tìm kiếm theo link Url (online).
  Future<AnimeResponse?> searchAnimeByUrl(String imageUrl) async {
    final uri = Uri.parse(
      'https://api.trace.moe/search?cutBorders&anilistInfo&url=$imageUrl',
    );

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        return AnimeResponse.fromJson(json.decode(response.body));
      } else {
        print('Lỗi truy vấn API: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Lỗi kết nối: $e');
      return null;
    }
  }
}
