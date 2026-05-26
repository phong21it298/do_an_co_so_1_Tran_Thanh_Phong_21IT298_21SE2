import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/local/search_history.dart';
import 'package:app_03/viewmodels/search_history_viewmodel.dart';
import '../viewmodels/auth_view_model.dart';
import 'package:app_03/utils/build_image_from_path.dart';

class SearchHistoryScreen extends StatefulWidget {
  const SearchHistoryScreen({super.key});

  @override
  State<SearchHistoryScreen> createState() => _SearchHistoryScreenState();
}

class _SearchHistoryScreenState extends State<SearchHistoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = context.read<AuthViewModel>().currentUserId;

      if (userId != null) {
        context.read<SearchHistoryViewModel>().loadHistories(userId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final historyVM = context.watch<SearchHistoryViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Lịch sử tìm kiếm"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/home');
          },
        ),
      ),
      body: historyVM.histories.isEmpty
          ? Center(
              child: Image.asset('assets/images/no_result.jpg', height: 200),
            )
          : ListView.builder(
              itemCount: historyVM.histories.length,
              itemBuilder: (context, index) {
                final history = historyVM.histories[index];
                return Card(
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: SizedBox(
                        width: 50,
                        height: 50,
                        child: BuildImageFromPath(imagePath: history.imagePath),
                      ),
                    ),
                    title: Text(
                      history.animeTitle,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      DateFormat(
                        'dd/MM/yyyy – HH:mm',
                      ).format(history.timestamp),
                      style: const TextStyle(color: Colors.grey),
                    ),
                    onTap: () => _showOptions(context, history),
                  ),
                );
              },
            ),
    );
  }

  void _showOptions(BuildContext context, SearchHistory history) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Tuỳ chọn"),
        content: Text("Bạn muốn làm gì với lịch sử này?"),
        actions: [
          TextButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text("Xác nhận"),
                  content: const Text("Bạn có chắc chắn muốn xoá?"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Hủy"),
                    ),
                    TextButton(
                      onPressed: () {
                        context.read<SearchHistoryViewModel>().deleteHistory(
                          history.id!,
                        );
                        Navigator.pop(context); //close confirm.
                        Navigator.pop(context); //close options.
                      },
                      child: const Text("Xoá"),
                    ),
                  ],
                ),
              );
            },
            child: const Text("Xoá"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showEditDialog(context, history);
            },
            child: const Text("Chỉnh sửa"),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, SearchHistory history) {
    final controller = TextEditingController(text: history.animeTitle);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Chỉnh sửa tiêu đề"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: "Tiêu đề mới"),
        ),
        actions: [
          TextButton(
            onPressed: () {
              final newTitle = controller.text.trim();
              if (newTitle.isNotEmpty) {
                final updated = SearchHistory(
                  id: history.id,
                  userId: history.userId,
                  imagePath: history.imagePath,
                  animeTitle: newTitle,
                  timestamp: history.timestamp,
                );
                context.read<SearchHistoryViewModel>().updateHistory(updated);
              }
              Navigator.pop(context);
            },
            child: const Text("Lưu"),
          ),
        ],
      ),
    );
  }
}
