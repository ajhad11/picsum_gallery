import 'package:picsum_gallery/features/gallery/domain/entities/image_entity.dart';

class ImageModel extends ImageEntity {
  const ImageModel({
    required super.id,
    required super.author,
    required super.downloadUrl,
    required super.width,
    required super.height,
  });

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(
      id: json['id'] as String,
      author: json['author'] as String,
      downloadUrl: json['download_url'] as String,
      width: json['width'] as int,
      height: json['height'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'author': author,
      'download_url': downloadUrl,
      'width': width,
      'height': height,
    };
  }
}
