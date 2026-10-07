class MessageModel {
  final String id;
  final String conversationId;
  final String senderId;
  final String body;
  final String? attachmentUrl;
  final String messageType;
  final bool isRead;
  final DateTime? readAt;
  final DateTime createdAt;

  const MessageModel({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.body,
    this.attachmentUrl,
    this.messageType = 'text',
    this.isRead = false,
    this.readAt,
    required this.createdAt,
  });

  bool isMine(String myId) => senderId == myId;

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      id: '${map['id'] ?? ''}',
      conversationId: '${map['conversation_id'] ?? ''}',
      senderId: '${map['sender_id'] ?? ''}',
      body: '${map['body'] ?? ''}',
      attachmentUrl: map['attachment_url']?.toString(),
      messageType: '${map['message_type'] ?? 'text'}',
      isRead: map['is_read'] == true ||
          map['is_read'] == 1 ||
          map['is_read'] == '1',
      readAt: DateTime.tryParse('${map['read_at'] ?? ''}'),
      createdAt: DateTime.tryParse('${map['created_at'] ?? ''}') ??
          DateTime.now(),
    );
  }
}
