import 'package:equatable/equatable.dart';

class PicsumImage extends Equatable {
  final String id;
  final String author;
  final int width;
  final int height;
  final String url;
  final String downloadUrl;

  const PicsumImage({
    required this.id,
    required this.author,
    required this.width,
    required this.height,
    required this.url,
    required this.downloadUrl,
  });

  factory PicsumImage.fromJson(Map<String, dynamic> json) {
    return PicsumImage(
      id: json['id'] as String,
      author: json['author'] as String,
      width: json['width'] as int,
      height: json['height'] as int,
      url: json['url'] as String,
      downloadUrl: json['download_url'] as String,
    );
  }

  @override
  List<Object?> get props => [id, author, width, height, url, downloadUrl];
}
