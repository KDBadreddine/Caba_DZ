import 'user_model.dart';

class ConversationModel {
  final String id;
  final String userOneId;
  final String userTwoId;
  final String? matchId;
  final String lastMessage;
  final DateTime? lastMessageAt;
  final String? lastSenderId;
  final int userOneUnread;
  final int userTwoUnread;
  final UserModel otherUser;

  const ConversationModel({
    required this.id,
    required this.userOneId,
    required this.userTwoId,
    this.matchId,
    this.lastMessage = '',
    this.lastMessageAt,
    this.lastSenderId,
    this.userOneUnread = 0,
    this.userTwoUnread = 0,
    required this.otherUser,
  });

  int unreadFor(String myId) =>
      myId == userOneId ? userOneUnread : userTwoUnread;

  bool isUserOne(String myId) => myId == userOneId;

  bool get isOnline => otherUser.isOnline;

  factory ConversationModel.fromMap(
    Map<String, dynamic> map, {
    required String myId,
    UserModel? otherUser,
  }) {
    final one = '${map['user_one_id'] ?? ''}';
    final two = '${map['user_two_id'] ?? ''}';
    final otherId = one == myId ? two : one;
    return ConversationModel(
      id: '${map['id'] ?? ''}',
      userOneId: one,
      userTwoId: two,
      matchId: map['match_id']?.toString(),
      lastMessage: '${map['last_message'] ?? ''}',
      lastMessageAt: DateTime.tryParse('${map['last_message_at'] ?? ''}'),
      lastSenderId: map['last_sender_id']?.toString(),
      userOneUnread: int.tryParse('${map['user_one_unread'] ?? 0}') ?? 0,
      userTwoUnread: int.tryParse('${map['user_two_unread'] ?? 0}') ?? 0,
      otherUser: otherUser ??
          UserModel(
            id: otherId,
            fullName: 'مستخدم',
            phone: '',
            email: '',
          ),
    );
  }
}
