import 'package:flutter/material.dart';
import '../ViewModel/gif_detail_view_model.dart';

class DetailScreen extends StatelessWidget {
  final GifDetailViewModel viewModel;

  const DetailScreen({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(viewModel.title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildGifImage(),
              const SizedBox(height: 20),
              ...viewModel.detailItems.map((item) => _buildDetailText(item)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGifImage() {
    return Center(
      child: Image.network(
        viewModel.gifUrl,
        fit: BoxFit.contain,
        loadingBuilder: (context, child, loadingProgress) {
          return loadingProgress == null
              ? child
              : const CircularProgressIndicator();
        },
      ),
    );
  }

  Widget _buildDetailText(DetailItem item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${item.label}: ${item.value}',
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
