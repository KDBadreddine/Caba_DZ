import 'package:flutter/material.dart';
import '../../app/routes.dart';
import '../../core/api/shared_data.dart';
import '../../core/constants/app_strings.dart';
import '../../core/widgets/caba_dialogs.dart';
import '../../models/conversation_model.dart';

Future<void> openChat(
  BuildContext context, {
  required String otherUserId,
  String? userName,
  String? userAvatar,
  ConversationModel? conversation,
}) async {
  if (otherUserId.isEmpty && conversation != null) {
    otherUserId = conversation.otherUser.id;
  }
  if (otherUserId.isEmpty) return;
  if (otherUserId == userInfo?.id) {
    showCabaErrorSnack(context, AppStrings.selfChatAr);
    return;
  }
  await Navigator.pushNamed(
    context,
    AppRoutes.chat,
    arguments: {
      'otherUserId': otherUserId,
      'userName': userName ?? conversation?.otherUser.fullName ?? 'محادثة',
      'userAvatar': userAvatar ?? conversation?.otherUser.avatarUrl,
      'conversation': conversation,
    },
  );
}
