import 'package:flutter/material.dart';
import '../View/gif_detail_screen.dart';
import '../Model/gif_model.dart';
import '../ViewModel/gif_detail_view_model.dart';

class NavigationService {
  static void navigateToDetailScreen(BuildContext context, GifModel gifModel) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailScreen(
          viewModel: GifDetailViewModel(gifModel: gifModel),
        ),
      ),
    );
  }
}
