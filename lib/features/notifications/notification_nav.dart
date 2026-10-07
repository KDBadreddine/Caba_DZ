import 'package:flutter/material.dart';
import '../../app/routes.dart';
import '../../core/api/api_functions.dart';
import '../../core/api/shared_data.dart';
import '../../core/constants/app_strings.dart';
import '../../core/widgets/caba_dialogs.dart';
import '../../models/notification_model.dart';
import '../chat/chat_nav.dart';

bool _hasId(String? id) =>
    id != null && id.isNotEmpty && id != 'null';

Future<void> openNotificationTarget(
  BuildContext context,
  AppNotification notification,
) async {
  if (!notification.isRead) {
    await markNotificationRead(notification.id);
  }

  final matchId = notification.relatedMatchId;
  if (!notification.hasRelatedOrder) {
    if (!context.mounted) return;
    await Navigator.pushNamed(context, AppRoutes.orders);
    return;
  }

  final match = await getMatchById(matchId!);
  if (!context.mounted) return;
  if (match == null) {
    showCabaErrorSnack(context, AppStrings.orderUnavailable);
    await Navigator.pushNamed(context, AppRoutes.orders);
    return;
  }

  final me = currentUser.id;
  final preferTrip = match.iAmTraveler(me) || !match.iAmSender(me);

  if (preferTrip && _hasId(match.tripId)) {
    final trip = await getTripById(match.tripId);
    if (!context.mounted) return;
    if (trip != null) {
      await Navigator.pushNamed(context, AppRoutes.tripDetail, arguments: trip);
      return;
    }
  }

  if (_hasId(match.requestId)) {
    final shipment = await getRequestById(match.requestId);
    if (!context.mounted) return;
    if (shipment != null) {
      await Navigator.pushNamed(
        context,
        AppRoutes.shipmentDetail,
        arguments: shipment,
      );
      return;
    }
  }

  if (_hasId(match.tripId)) {
    final trip = await getTripById(match.tripId);
    if (!context.mounted) return;
    if (trip != null) {
      await Navigator.pushNamed(context, AppRoutes.tripDetail, arguments: trip);
      return;
    }
  }

  final otherId = match.iAmTraveler(me) ? match.senderId : match.travelerId;
  if (_hasId(otherId)) {
    await openChat(context, otherUserId: otherId);
    return;
  }

  if (!context.mounted) return;
  await Navigator.pushNamed(context, AppRoutes.orders);
}
