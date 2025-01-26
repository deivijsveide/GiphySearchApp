class GifModel {
  final String gifUrl;
  final String? originalUrl;
  final String? title;
  final String? username;
  final String? rating;
  final String? uploadDate;
  final String? source;
  final String? sourcePostUrl;
  final String? embedUrl;

  GifModel({
    required this.gifUrl,
    this.originalUrl,
    this.title,
    this.username,
    this.rating,
    this.uploadDate,
    this.source,
    this.sourcePostUrl,
    this.embedUrl,
  });

  factory GifModel.fromJson(Map<String, dynamic> json) {
    return GifModel(
      gifUrl: json['images']['fixed_height']['url'],
      originalUrl: json['images']['original']['url'],
      title: json['title'],
      username: json['username'],
      rating: json['rating'],
      uploadDate: json['import_datetime'],
      source: json['source'],
      sourcePostUrl: json['source_post_url'],
      embedUrl: json['embed_url'],
    );
  }

  Map<String, String?> toDetailMap() {
    return {
      'Creator': username,
      'Rating': rating,
      'Upload Date': uploadDate,
      'Source': source,
      'Source Post': sourcePostUrl,
      'Original URL': originalUrl,
      'Embed URL': embedUrl,
    };
  }
}
