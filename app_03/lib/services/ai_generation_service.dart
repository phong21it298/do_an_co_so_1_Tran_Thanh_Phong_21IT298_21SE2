import 'dart:typed_data';
import 'package:http/http.dart' as http;

class AiGenerationService {

  //Sinh ảnh từ đoạn vb nhập vào.
  Future<Uint8List?> generateAnimeImage(String prompt) async {

    //Thêm vài từ khóa mồi để ép AI vẽ ra đúng chất anime.
    //encodeComponent -> chuyển đổi các ký tự đặc biệt trong vb thành định dạng mà URL hiểu được.
    final optimizedPrompt = Uri.encodeComponent("anime style, master piece, high quality, $prompt");

    //Pollinations cho phép lấy ảnh trực tiếp qua URL. Free, ko cần API key.
    final url = Uri.parse('https://image.pollinations.ai/prompt/$optimizedPrompt?width=1024&height=1024&nologo=true');

    try {

      final response = await http.get(url);

      if (response.statusCode == 200) {
        return response.bodyBytes; //Trả về file ảnh luôn (dưới mảng các con số).
      }
    } catch (e) {
      print("Lỗi sinh ảnh AI: $e");
    }
    return null;
  }
}