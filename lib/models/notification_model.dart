class AppNotification {
  final String id;
  final String userId;
  final String title;
  final String body;
  final String? relatedMatchId;
  final bool isRead;
  final DateTime createdAt;

  const AppNotification({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    this.relatedMatchId,
    this.isRead = false,
    required this.createdAt,
  });

  factory AppNotification.fromMap(Map<String, dynamic> map) {
    return AppNotification(
      id: '${map['id'] ?? ''}',
      userId: '${map['user_id'] ?? ''}',
      title: '${map['title'] ?? ''}',
      body: '${map['body'] ?? ''}',
      relatedMatchId: map['related_match_id']?.toString(),
      isRead: map['is_read'] == 1 || map['is_read'] == true,
      createdAt:
          DateTime.tryParse('${map['created_at'] ?? ''}') ?? DateTime.now(),
    );
  }

  bool get hasRelatedOrder {
    final id = relatedMatchId;
    return id != null && id.isNotEmpty && id != 'null';
  }
}
