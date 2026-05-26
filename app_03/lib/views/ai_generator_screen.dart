import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../viewmodels/ai_view_model.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class AiGeneratorScreen extends StatefulWidget {

  const AiGeneratorScreen({super.key});

  @override
  State<AiGeneratorScreen> createState() => _AiGeneratorScreenState();
}

class _AiGeneratorScreenState extends State<AiGeneratorScreen> {

  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose(); //Giải phóng bộ nhớ khi thoát màn hình.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    //watch để lắng nghe thay đổi từ ViewModel.
    final aiVM = context.watch<AiViewModel>();

    return Scaffold(

      //Cho phép body tràn lên dưới AppBar.
      extendBodyBehindAppBar: true,

      appBar: AppBar(
        title: const Text(
          "AI Anime Generator",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          if (aiVM.generatedImage != null)
            IconButton(
              icon: const Icon(Icons.clear, color: Colors.white),
              onPressed: () {
                _controller.clear();
                aiVM.clear();
              },
            )
        ],
      ),
      body: Stack(
        children: [
          //Ảnh nền.
          Positioned.fill(
            child: Image.asset(
              'assets/images/tiphera.png',
              fit: BoxFit.cover,
            ),
          ),

          //Lớp phủ mờ (Overlay) để các phần tử UI nổi bật hơn.
          Positioned.fill(
            child: Container(
              color: Colors.white.withOpacity(0.4), //Độ mờ.
            ),
          ),

          //Lớp nội dung chính.
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  //Ô nhập liệu.
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        labelText: "Mô tả nhân vật (bằng tiếng Anh nhé!)",
                        hintText: "Ví dụ: cute girl with blue hair",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.send, color: Colors.pink),
                          onPressed: aiVM.isLoading
                              ? null
                              : () => aiVM.generateImage(_controller.text),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  //Khu vực hiển thị kết quả AI.
                  Expanded(
                    child: Center(
                      child: aiVM.isLoading
                          ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Column(
                              children: [
                                CircularProgressIndicator(color: Colors.pink),
                                SizedBox(height: 15),
                                Text(
                                  "AI đang vẽ, đợi xíu nhé...",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                          : aiVM.generatedImage != null
                          ? Column(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 15,
                                    offset: Offset(0, 8),
                                  )
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.memory(aiVM.generatedImage!),
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          //Nút chia sẻ.
                          ElevatedButton.icon(
                            onPressed: () async {
                              if (aiVM.generatedImage != null) {
                                try {
                                  //Lấy thư mục tạm của điện thoại.
                                  final tempDir = await getTemporaryDirectory();

                                  //Tạo đường dẫn file (ví dụ: ai_image.png).
                                  final filePath = '${tempDir.path}/ai_generated_image.png';

                                  //Ghi dữ liệu bytes (Uint8List) vào file đó.
                                  final file = File(filePath);
                                  await file.writeAsBytes(aiVM.generatedImage!);

                                  //Chia sẻ file ảnh kèm theo lời nhắn.
                                  await Share.shareXFiles(
                                    [XFile(filePath)],
                                    text: "Nhìn tấm ảnh Anime AI vẽ từ mô tả '${_controller.text}' của tui nè! xịn chưa?",
                                  );
                                } catch (e) {
                                  debugPrint("Lỗi khi chia sẻ ảnh: $e");
                                  //Nếu lỗi chia sẻ file, thì chia sẻ text như cũ.
                                  Share.share("Mô tả: ${_controller.text}");
                                }
                              }
                            },
                            icon: const Icon(Icons.share),
                            label: const Text("Chia sẻ với bạn bè"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                          )
                        ],
                      )
                          : Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.image_search,
                                size: 80, color: Colors.pinkAccent),
                            SizedBox(height: 10),
                            Text(
                              "Nhập mô tả và nhấn nút gửi\nđể bắt đầu tạo ảnh Anime nhé!",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}