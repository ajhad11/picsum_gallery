import 'package:equatable/equatable.dart';

class ImageEntity extends Equatable {
  final String id;
  final String author;
  final String downloadUrl;
  final int width;
  final int height;

  const ImageEntity({
    required this.id,
    required this.author,
    required this.downloadUrl,
    required this.width,
    required this.height,
  });

  @override
  List<Object?> get props => [id, author, downloadUrl, width, height];
}
