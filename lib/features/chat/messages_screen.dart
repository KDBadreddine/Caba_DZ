import 'package:flutter/material.dart';
import '../../app/theme.dart';
import '../../core/api/api_functions.dart';
import '../../core/api/shared_data.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/date_format.dart';
import '../../core/widgets/caba_app_bar.dart';
import '../../core/widgets/caba_avatar.dart';
import '../../core/widgets/caba_bottom_nav.dart';
import '../../core/widgets/caba_empty_state.dart';
import '../../models/conversation_model.dart';
import 'chat_nav.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  List<ConversationModel> _items = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    touchLastSeen();
    _load();
  }

  Future<void> _load() async {
    final list = await getMyConversations();
    if (!mounted) return;
    setState(() {
      _items = list;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CabaAppBar(
        titleText: AppStrings.conversationsAr,
        showBack: false,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _items.isEmpty
              ? Center(
                  child: CabaEmptyState(
                    icon: Icons.chat_bubble_outline_rounded,
                    title: AppStrings.noConversations,
                    subtitle: AppStrings.emptyMessagesSub,
                  ),
                )
              : RefreshIndicator(
                  color: AppColors.primary,
                  onRefresh: _load,
                  child: ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    itemCount: _items.length,
                    separatorBuilder: (_, _) =>
                        const Divider(height: 1, indent: 72),
                    itemBuilder: (_, i) => _ConversationTile(
                      conversation: _items[i],
                      onOpen: () async {
                        await openChat(
                          context,
                          otherUserId: _items[i].otherUser.id,
                          userName: _items[i].otherUser.fullName,
                          userAvatar: _items[i].otherUser.avatarUrl,
                          conversation: _items[i],
                        );
                        if (mounted) _load();
                      },
                    ),
                  ),
                ),
      bottomNavigationBar: CabaBottomNav(
        currentIndex: 3,
        onTap: (i) {
          if (i == 3) return;
          navigateMainTab(context, i);
        },
      ),
    );
  }
}

class _ConversationTile extends StatelessWidget {
  final ConversationModel conversation;
  final VoidCallback onOpen;

  const _ConversationTile({
    required this.conversation,
    required this.onOpen,
  });

  @override
  Widget build(BuildContext context) {
    final user = conversation.otherUser;
    final unread = conversation.unreadFor(currentUser.id);
    final hasUnread = unread > 0;

    return InkWell(
      onTap: onOpen,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Stack(
              children: [
                CabaAvatar(
                  imageUrl: user.avatarUrl,
                  fallback: user.firstName,
                  radius: 26,
                ),
                if (conversation.isOnline)
                  Positioned(
                    bottom: 2,
                    left: 2,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: AppColors.success,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.fullName,
                    style: AppTextStyles.titleMedium.copyWith(
                      fontWeight: hasUnread ? FontWeight.w700 : FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    conversation.lastMessage.isEmpty
                        ? AppStrings.startConversation
                        : conversation.lastMessage,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: hasUnread
                          ? AppColors.textPrimary
                          : AppColors.textSecondary,
                      fontWeight:
                          hasUnread ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  formatChatTime(conversation.lastMessageAt),
                  style: AppTextStyles.bodySmall.copyWith(
                    color: hasUnread ? AppColors.primary : AppColors.textHint,
                    fontSize: 11,
                  ),
                ),
                if (hasUnread) ...[
                  const SizedBox(height: 6),
                  Container(
                    constraints: const BoxConstraints(minWidth: 20),
                    height: 20,
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      unread > 99 ? '99+' : '$unread',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
