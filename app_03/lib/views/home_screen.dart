import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/home_view_model.dart';
import '../viewmodels/auth_view_model.dart';
import 'package:app_03/views/result_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final homeVM = context.watch<HomeViewModel>();

    final imageWidget = homeVM.selectedImageBytes != null
        ? Image.memory(homeVM.selectedImageBytes!, height: 200)
        : homeVM.imageUrl != null
        ? Image.network(homeVM.imageUrl!, height: 200)
        : Image.asset('assets/images/placeholder.jpg', height: 200);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Anime Search'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => Navigator.pushNamed(context, '/history'),
          ),
          //Mở màn hình sinh văn bản.
          IconButton(
            tooltip: "Sinh ảnh AI",
            icon: const Icon(Icons.psychology),
            onPressed: () => Navigator.pushNamed(context, '/ai_gen'),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<HomeViewModel>().clearResult();
              context.read<AuthViewModel>().logout();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            //Row search by URL & image picker.
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      labelText: 'Dán URL ảnh',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (value) {
                      if (value.isNotEmpty) {
                        context.read<HomeViewModel>().searchByUrl(value);
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.image),
                  onPressed: () => context.read<HomeViewModel>().pickImageFromGallery(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            imageWidget,
            const SizedBox(height: 16),
            const Text('Kết quả', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Expanded(
              child: homeVM.animeResponse != null
                  ? ListView.builder(
                itemCount: homeVM.animeResponse!.result.length,
                itemBuilder: (context, index) {
                  final result = homeVM.animeResponse!.result[index];
                  return ResultCard(result: result);
                },
              )
                  : Image.asset('assets/images/no_result.jpg', height: 200),
            ),
          ],
        ),
      ),
    );
  }
}
