import '../config/config.dart';

class SliderModel {
  final String id;
  final String title;
  final String subtitle;
  final String imageUrl;
  final String? link;
  final int ordering;
  final String status;

  const SliderModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    this.link,
    this.ordering = 0,
    this.status = 'active',
  });

  bool get isActive => status == 'active';

  String get resolvedImageUrl {
    final raw = imageUrl.trim();
    if (raw.isEmpty) return '';
    if (raw.startsWith('http://') || raw.startsWith('https://')) return raw;
    if (raw.startsWith('/')) return '$website$raw';
    return '$uploadsUrl/$raw';
  }

  factory SliderModel.fromMap(Map<String, dynamic> map) {
    return SliderModel(
      id: '${map['id'] ?? ''}',
      title: '${map['title'] ?? ''}',
      subtitle: '${map['subtitle'] ?? ''}',
      imageUrl: '${map['image_url'] ?? map['image'] ?? ''}',
      link: map['link']?.toString(),
      ordering: int.tryParse('${map['ordering'] ?? 0}') ?? 0,
      status: '${map['status'] ?? 'active'}',
    );
  }
}
