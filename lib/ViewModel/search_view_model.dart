import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:easy_debounce/easy_debounce.dart';
import '../Services/giphy_api_service.dart';
import '../Model/gif_model.dart';

class SearchViewModel {
  static const _pageSize = 10;
  final GiphyApiService _apiService = GiphyApiService();

  final PagingController<int, Map<String, dynamic>> pagingController =
      PagingController(firstPageKey: 0);

  String _currentQuery = '';

  SearchViewModel() {
    pagingController.addPageRequestListener((pageKey) {
      fetchPage(pageKey);
    });
  }

  void onSearchChanged(String query) {
    EasyDebounce.debounce(
      'search-debouncer',
      Duration(milliseconds: 500),
      () {
        _currentQuery = query;
        pagingController.refresh();
      },
    );
  }

  Future<void> fetchPage(int pageKey) async {
    if (_currentQuery.isEmpty) {
      pagingController.appendLastPage([]);
      return;
    }

    try {
      final response =
          await _apiService.searchGifs(_currentQuery, _pageSize, pageKey);
      final List<Map<String, dynamic>> results =
          List<Map<String, dynamic>>.from(response['data']);

      final isLastPage = results.length < _pageSize;
      if (isLastPage) {
        pagingController.appendLastPage(results);
      } else {
        final nextPageKey = pageKey + results.length;
        pagingController.appendPage(results, nextPageKey);
      }
    } catch (error) {
      pagingController.error = error;
    }
  }

  GifModel getGifModel(int index) {
    final gifData = pagingController.itemList?[index];
    return GifModel.fromJson(gifData!);
  }

  void dispose() {
    pagingController.dispose();
    EasyDebounce.cancel('search-debouncer');
  }
}
