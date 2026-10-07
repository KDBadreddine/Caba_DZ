import 'dart:async';

import 'package:flutter/material.dart';
import '../../app/routes.dart';
import '../../app/theme.dart';
import '../../core/api/api_functions.dart';
import '../../core/api/shared_data.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/date_format.dart';
import '../../core/widgets/caba_app_bar.dart';
import '../../core/widgets/caba_avatar.dart';
import '../../core/widgets/caba_dialogs.dart';
import '../../features/match/match_confirm_dialog.dart';
import '../../models/conversation_model.dart';
import '../../models/match_model.dart';
import '../../models/message_model.dart';

class ChatScreen extends StatefulWidget {
  final String otherUserId;
  final String userName;
  final String? userAvatar;
  final ConversationModel? conversation;

  const ChatScreen({
    super.key,
    required this.otherUserId,
    required this.userName,
    this.userAvatar,
    this.conversation,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _msgCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();
  ConversationModel? _conversation;
  MatchModel? _match;
  List<MessageModel> _messages = [];
  bool _loading = true;
  bool _sending = false;
  bool _matching = false;
  Timer? _poll;

  @override
  void initState() {
    super.initState();
    _conversation = widget.conversation;
    _init();
  }

  Future<void> _init() async {
    touchLastSeen();
    _conversation ??= await findConversationWith(widget.otherUserId);
    if (!mounted) return;
    final conv = _conversation;
    if (conv != null) {
      await markConversationRead(conv);
      await Future.wait([_loadMessages(scroll: true), _loadMatch()]);
    }
    if (!mounted) return;
    setState(() => _loading = false);
    _poll = Timer.periodic(const Duration(seconds: 7), (_) {
      if (_sending || _matching) return;
      if (_conversation != null) {
        _loadMessages();
        _loadMatch();
      }
    });
  }

  Future<void> _loadMatch() async {
    final conv = _conversation;
    MatchModel? match;
    if (conv != null) {
      match = await getMatchForConversation(conv.id);
      if (match == null &&
          conv.matchId != null &&
          conv.matchId!.isNotEmpty) {
        match = await getMatchById(conv.matchId!);
      }
    }
    if (!mounted) return;
    if (match?.id == _match?.id &&
        match?.status == _match?.status &&
        match?.travelerConfirmed == _match?.travelerConfirmed &&
        match?.senderConfirmed == _match?.senderConfirmed &&
        match?.qrToken == _match?.qrToken) {
      return;
    }
    setState(() => _match = match);
  }

  Future<void> _loadMessages({bool scroll = false}) async {
    final conv = _conversation;
    if (conv == null) return;
    final list = await getMessages(conv.id);
    if (!mounted) return;
    final nearEnd = !_scrollCtrl.hasClients ||
        _scrollCtrl.position.pixels >=
            _scrollCtrl.position.maxScrollExtent - 80;
    final grew = list.length > _messages.length;
    setState(() => _messages = list);
    if (scroll || (grew && nearEnd)) _scrollToEnd();
  }

  void _scrollToEnd() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollCtrl.hasClients) return;
      _scrollCtrl.animateTo(
        _scrollCtrl.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  Future<void> _send() async {
    final text = _msgCtrl.text.trim();
    if (text.isEmpty || _sending) return;
    setState(() => _sending = true);
    _msgCtrl.clear();
    var conv = _conversation;
    conv ??= await getOrCreateConversation(otherUserId: widget.otherUserId);
    if (!mounted) return;
    if (conv == null) {
      _msgCtrl.text = text;
      setState(() => _sending = false);
      return;
    }
    _conversation = conv;
    final saved = await sendMessage(conversation: conv, body: text);
    if (!mounted) return;
    if (saved != null) {
      setState(() {
        _messages = [..._messages, saved];
        _sending = false;
      });
      _scrollToEnd();
      final fresh = await getConversationById(conv.id);
      if (fresh != null && mounted) _conversation = fresh;
    } else {
      _msgCtrl.text = text;
      setState(() => _sending = false);
    }
  }

  Future<void> _onMatchTap() async {
    if (_matching) return;
    final myId = currentUser.id;
    final existing = _match;
    String? role;
    if (existing != null &&
        (existing.iAmTraveler(myId) || existing.iAmSender(myId))) {
      role = existing.iAmTraveler(myId) ? 'traveler' : 'sender';
    }

    role ??= await inferMyMatchRole(widget.otherUserId);
    if (!mounted) return;

    final confirmedRole = await showMatchConfirmDialog(
      context,
      otherName: widget.userName,
      presetRole: role,
      otherAlreadyConfirmed:
          existing != null && existing.otherHasConfirmed(myId),
    );
    if (confirmedRole == null || !mounted) return;

    setState(() => _matching = true);
    final result = await confirmConversationMatch(
      otherUserId: widget.otherUserId,
      myRole: confirmedRole,
    );
    if (!mounted) return;
    setState(() => _matching = false);

    if (result == null) {
      showCabaErrorSnack(context, AppStrings.matchFailed);
      return;
    }

    _match = result.match;
    if (result.match.conversationId.isNotEmpty) {
      _conversation = await getConversationById(result.match.conversationId) ??
          _conversation;
    }
    _conversation ??= await findConversationWith(widget.otherUserId);
    if (_conversation != null) {
      await sendMessage(
        conversation: _conversation!,
        body: result.bothConfirmed
            ? 'تمت المطابقة ✓'
            : 'تم تأكيد المطابقة، بانتظار الطرف الآخر',
      );
      await _loadMessages(scroll: true);
    }
    if (!mounted) return;
    setState(() {});

    if (result.justActivated || result.bothConfirmed) {
      await showCabaSuccessDialog(
        context,
        title: AppStrings.matchReadyTitle,
        subtitle: AppStrings.matchReadySub,
      );
      if (mounted &&
          result.match.iAmSender(currentUser.id) &&
          result.match.hasQr) {
        await _openQr();
      }
    } else {
      await showCabaSuccessDialog(
        context,
        title: AppStrings.matchWaitingTitle,
        subtitle: AppStrings.matchWaitingSub,
      );
    }
    if (mounted) await _loadMatch();
  }

  Future<void> _openQr() async {
    final match = _match;
    if (match == null || !match.hasQr) return;
    await Navigator.pushNamed(
      context,
      AppRoutes.matchQr,
      arguments: {'match': match, 'otherName': widget.userName},
    );
  }

  Future<void> _openScan() async {
    final match = _match;
    if (match == null) return;
    final done = await Navigator.pushNamed(
      context,
      AppRoutes.scanDelivery,
      arguments: match,
    );
    if (done == true && mounted) await _loadMatch();
  }

  @override
  void dispose() {
    _poll?.cancel();
    _msgCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final other = _conversation?.otherUser;
    final name = other?.fullName ?? widget.userName;
    final avatar = other?.avatarUrl ?? widget.userAvatar;
    final online = other?.isOnline ?? false;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CabaAppBar(
        centerTitle: false,
        onBack: () => Navigator.pop(context, true),
        title: Row(
          children: [
            CabaAvatar(
              imageUrl: avatar,
              fallback: name,
              radius: 18,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: AppTextStyles.titleMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    online ? AppStrings.onlineAr : AppStrings.offlineAr,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: online ? AppColors.success : AppColors.textHint,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _MatchBar(
                  match: _match,
                  otherName: name,
                  matching: _matching,
                  onMatch: _onMatchTap,
                  onViewQr: _openQr,
                  onScan: _openScan,
                ),
                Expanded(
                  child: _messages.isEmpty
                      ? Center(
                          child: Text(
                            AppStrings.startFirstMessage,
                            style: AppTextStyles.bodyMedium,
                          ),
                        )
                      : ListView.builder(
                          controller: _scrollCtrl,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          itemCount: _messages.length,
                          itemBuilder: (_, i) => _Bubble(
                            msg: _messages[i],
                            isMine: _messages[i].isMine(currentUser.id),
                          ),
                        ),
                ),
                _buildInputBar(),
              ],
            ),
    );
  }

  Widget _buildInputBar() {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _msgCtrl,
                style: AppTextStyles.bodyLarge,
                textInputAction: TextInputAction.send,
                decoration: InputDecoration(
                  hintText: AppStrings.messageHintAr,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
                onSubmitted: (_) => _send(),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: _sending ? null : _send,
              child: Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: _sending
                    ? const Padding(
                        padding: EdgeInsets.all(12),
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.send_rounded,
                        color: Colors.white, size: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MatchBar extends StatelessWidget {
  final MatchModel? match;
  final String otherName;
  final bool matching;
  final VoidCallback onMatch;
  final VoidCallback onViewQr;
  final VoidCallback onScan;

  const _MatchBar({
    required this.match,
    required this.otherName,
    required this.matching,
    required this.onMatch,
    required this.onViewQr,
    required this.onScan,
  });

  @override
  Widget build(BuildContext context) {
    final myId = currentUser.id;
    final m = match;
    String statusText;
    Widget? action;

    if (m == null || m.isCancelled) {
      statusText = AppStrings.matchDialogTitle;
      action = _pill(
        label: AppStrings.match,
        icon: Icons.handshake_rounded,
        onTap: matching ? null : onMatch,
      );
    } else if (m.isDelivered) {
      statusText = AppStrings.deliveryCompleted;
    } else if (m.isConfirmed && m.hasQr) {
      final isSender = m.iAmSender(myId);
      statusText = AppStrings.matchReadyTitle;
      action = isSender
          ? _pill(
              label: AppStrings.viewQr,
              icon: Icons.qr_code_2_rounded,
              onTap: onViewQr,
            )
          : _pill(
              label: AppStrings.scanToComplete,
              icon: Icons.qr_code_scanner_rounded,
              onTap: onScan,
            );
    } else if (m.iHaveConfirmed(myId) && !m.otherHasConfirmed(myId)) {
      statusText = AppStrings.waitingForConfirm(otherName);
    } else if (!m.iHaveConfirmed(myId) && m.otherHasConfirmed(myId)) {
      statusText = AppStrings.theyConfirmedMatch;
      action = _pill(
        label: AppStrings.confirmMatch,
        icon: Icons.check_rounded,
        onTap: matching ? null : onMatch,
      );
    } else {
      statusText = AppStrings.matchDialogTitle;
      action = _pill(
        label: AppStrings.match,
        icon: Icons.handshake_rounded,
        onTap: matching ? null : onMatch,
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 10, 12, 10),
      decoration: const BoxDecoration(
        color: AppColors.primaryLight,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          if (matching)
            const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          else
            Icon(
              m?.isDelivered == true
                  ? Icons.check_circle_rounded
                  : Icons.handshake_rounded,
              color: AppColors.primary,
              size: 20,
            ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              statusText,
              style: AppTextStyles.titleMedium.copyWith(fontSize: 13),
            ),
          ),
          ?action,
        ],
      ),
    );
  }

  Widget _pill({
    required String label,
    required IconData icon,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 16),
            const SizedBox(width: 6),
            Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  final MessageModel msg;
  final bool isMine;

  const _Bubble({required this.msg, required this.isMine});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMine ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.72,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isMine ? AppColors.primary : AppColors.surfaceVariant,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft:
                isMine ? const Radius.circular(4) : const Radius.circular(16),
            bottomRight:
                isMine ? const Radius.circular(16) : const Radius.circular(4),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              msg.body,
              style: AppTextStyles.bodyLarge.copyWith(
                color: isMine ? Colors.white : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              formatTimeHm(msg.createdAt),
              style: AppTextStyles.bodySmall.copyWith(
                color: isMine ? Colors.white70 : AppColors.textHint,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
