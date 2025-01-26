import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../ViewModel/search_view_model.dart';
import '../Services/navigation_service.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final SearchViewModel _viewModel = SearchViewModel();

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Giphy Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSearchField(),
            SizedBox(height: 16),
            _buildGifGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      onChanged: _viewModel.onSearchChanged,
      decoration: InputDecoration(
        labelText: 'Search GIFs',
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildGifGrid() {
    return Expanded(
      child: OrientationBuilder(
        builder: (context, orientation) {
          return PagedGridView<int, Map<String, dynamic>>(
            pagingController: _viewModel.pagingController,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: orientation == Orientation.portrait ? 2 : 4,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 1.0,
            ),
            builderDelegate: PagedChildBuilderDelegate<Map<String, dynamic>>(
              itemBuilder: (context, item, index) =>
                  _buildGifItem(item['images']['fixed_height']['url'], index),
              firstPageProgressIndicatorBuilder: (_) => Center(
                child: CircularProgressIndicator(),
              ),
              noItemsFoundIndicatorBuilder: (_) => Center(
                child: Text('No GIFs found'),
              ),
              firstPageErrorIndicatorBuilder: (context) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Something went wrong.'),
                    ElevatedButton(
                      onPressed: () => _viewModel.pagingController.refresh(),
                      child: Text('Try Again'),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildGifItem(String imageUrl, int index) {
    return GestureDetector(
      onTap: () => NavigationService.navigateToDetailScreen(
        context,
        _viewModel.getGifModel(index),
      ),
      child: Card(
        elevation: 2,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
