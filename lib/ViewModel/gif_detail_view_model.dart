import '../Model/gif_model.dart';

class DetailItem {
  final String label;
  final String value;
  const DetailItem({required this.label, required this.value});
}

class GifDetailViewModel {
  final GifModel _gifModel;

  const GifDetailViewModel({required GifModel gifModel}) : _gifModel = gifModel;

  String get title => _gifModel.title ?? 'GIF Details';
  String get gifUrl => _gifModel.gifUrl;

  List<DetailItem> get detailItems {
    final Map<String, String?> details = _gifModel.toDetailMap();
    return details.entries
        .map((e) => DetailItem(label: e.key, value: e.value ?? 'Not available'))
        .toList();
  }
}
