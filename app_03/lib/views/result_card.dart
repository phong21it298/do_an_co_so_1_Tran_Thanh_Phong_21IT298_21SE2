import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/home_view_model.dart';
import '../viewmodels/auth_view_model.dart';
import 'package:app_03/model/api/result.dart';
import 'package:video_player/video_player.dart';
import 'package:share_plus/share_plus.dart';  //share.

class ResultCard extends StatefulWidget {
  final Result result;

  const ResultCard({super.key, required this.result});
  @override
  State<ResultCard> createState() => _ResultCardState();
}

class _ResultCardState extends State<ResultCard> {
  late VideoPlayerController _controller;
  bool isEnded = false;

  //Gọi khi widget được tạo.
  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.result.video))
    ..initialize().then((_) { //Load video.
        setState(() {}); //Rebuild khi đã load xong video.
      }).catchError((error) {
      debugPrint('Lỗi load video: $error');
    });

    _controller.addListener(() {
      final position = _controller.value.position;
      final duration = _controller.value.duration;

      //Video kết thúc nếu đang không phát và vị trí tại đầu.
      final ended = !_controller.value.isPlaying &&
          duration != null &&
          position >= duration;

      if (ended != isEnded) {
        setState(() {
          isEnded = ended;
        });
      }
    });
  }

  //Giải phóng _controller khi widget bị hủy.
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String get animeTitle {
    return widget.result.anilist.title.romaji?.isNotEmpty == true
        ? widget.result.anilist.title.romaji!
        : widget.result.anilist.title.native;
  }

  String formatDuration(double seconds) {
    final duration = Duration(seconds: seconds.floor());
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final secs = twoDigits(duration.inSeconds.remainder(60));
    return '$hours:$minutes:$secs';
  }

  @override
  Widget build(BuildContext context) {
    final authVM = context.read<AuthViewModel>();
    final homeVM = context.read<HomeViewModel>();
    final result = widget.result;

    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text(animeTitle),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.network(result.image),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly, //Cách đều 2 nút.
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        final userId = authVM.currentUserId; //Lấy userId từ AuthViewModel.

                        final imageToSave = homeVM.selectedImageBytes != null
                            ? base64Encode(homeVM.selectedImageBytes!)
                            : homeVM.imageUrl ?? "";

                        homeVM.saveToHistory(
                          userId: userId,
                          imagePath: imageToSave,
                          animeTitle: animeTitle,
                        );

                        Navigator.pop(context);
                      },
                      child: const Text('Lưu'),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        final info = '''
                      🌟 Tìm thấy Anime này nè!
                      🎬 Phim: $animeTitle
                      🎞 Tập: ${result.episode ?? "Không rõ"}
                      ⏱ Thời gian: ${formatDuration(result.from)}
                      🔗 Ảnh: ${result.image}
                      ''';
                        Share.share(info);  //Gọi bảng chia sẻ hệ thống.
                      },
                      icon: const Icon(Icons.share),
                      label: const Text('Chia sẻ'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                animeTitle,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 4),
              Text('Episode: ${result.episode ?? "Unknown"}'),
              Text('From: ${formatDuration(result.from)}'),
              Text('To: ${formatDuration(result.to)}'),
              Text('Similarity: ${(result.similarity * 100).toStringAsFixed(2)}%'),
              const SizedBox(height: 8),
              if (_controller.value.isInitialized)
                AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      VideoPlayer(_controller),
                      VideoProgressIndicator(_controller, allowScrubbing: true),
                      IconButton(
                        icon: Icon(
                          isEnded
                              ? Icons.replay
                              : (_controller.value.isPlaying ? Icons.pause : Icons.play_arrow),
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            if (isEnded) {
                              _controller.seekTo(Duration.zero);
                              _controller.play();
                            } else {
                              _controller.value.isPlaying
                                  ? _controller.pause()
                                  : _controller.play();
                            }
                          });
                        },
                      ),
                    ],
                  ),
                )
              else
                const Center(child: CircularProgressIndicator()),
            ],
          ),
        ),
      )
    );
  }
}
