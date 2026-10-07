class MatchModel {
  static const qrPrefix = 'caba';

  final String id;
  final String tripId;
  final String requestId;
  final String conversationId;
  final String travelerId;
  final String senderId;
  final bool travelerConfirmed;
  final bool senderConfirmed;
  final double agreedPrice;
  final String currency;
  final bool prohibitedAck;
  final String? handoverPhotoUrl;
  final String? deliveryCode;
  final String? qrToken;
  final String status;
  final DateTime createdAt;

  const MatchModel({
    required this.id,
    this.tripId = '',
    this.requestId = '',
    this.conversationId = '',
    this.travelerId = '',
    this.senderId = '',
    this.travelerConfirmed = false,
    this.senderConfirmed = false,
    required this.agreedPrice,
    this.currency = 'EUR',
    this.prohibitedAck = false,
    this.handoverPhotoUrl,
    this.deliveryCode,
    this.qrToken,
    this.status = 'pending',
    required this.createdAt,
  });

  bool get bothConfirmed => travelerConfirmed && senderConfirmed;

  bool get isPending => status == 'pending';

  bool get isConfirmed =>
      status == 'confirmed' || status == 'handed_over';

  bool get isDelivered => status == 'delivered';

  bool get isCancelled => status == 'cancelled';

  bool iAmTraveler(String userId) => travelerId == userId;

  bool iAmSender(String userId) => senderId == userId;

  bool iHaveConfirmed(String userId) {
    if (iAmTraveler(userId)) return travelerConfirmed;
    if (iAmSender(userId)) return senderConfirmed;
    return false;
  }

  bool otherHasConfirmed(String userId) {
    if (iAmTraveler(userId)) return senderConfirmed;
    if (iAmSender(userId)) return travelerConfirmed;
    return false;
  }

  bool get hasQr => qrToken != null && qrToken!.isNotEmpty;

  String get qrPayload => '$qrPrefix:$id:${qrToken ?? ''}';

  static bool _flag(dynamic v) => v == true || v == 1 || v == '1';

  factory MatchModel.fromMap(Map<String, dynamic> map) {
    return MatchModel(
      id: '${map['id'] ?? ''}',
      tripId: '${map['trip_id'] ?? ''}',
      requestId: '${map['request_id'] ?? ''}',
      conversationId: '${map['conversation_id'] ?? ''}',
      travelerId: '${map['traveler_id'] ?? ''}',
      senderId: '${map['sender_id'] ?? ''}',
      travelerConfirmed: _flag(map['traveler_confirmed']),
      senderConfirmed: _flag(map['sender_confirmed']),
      agreedPrice: double.tryParse('${map['agreed_price'] ?? 0}') ?? 0,
      currency: '${map['currency'] ?? 'EUR'}',
      prohibitedAck: _flag(map['prohibited_ack']),
      handoverPhotoUrl: map['handover_photo_url']?.toString(),
      deliveryCode: map['delivery_code']?.toString(),
      qrToken: map['qr_token']?.toString(),
      status: '${map['status'] ?? 'pending'}',
      createdAt:
          DateTime.tryParse('${map['created_at'] ?? ''}') ?? DateTime.now(),
    );
  }

  /// Payload format: `caba:{matchId}:{qrToken}`
  static ({String matchId, String token})? parseQrPayload(String raw) {
    final parts = raw.trim().split(':');
    if (parts.length != 3) return null;
    if (parts[0] != qrPrefix) return null;
    if (parts[1].isEmpty || parts[2].isEmpty) return null;
    return (matchId: parts[1], token: parts[2]);
  }
}

class MatchConfirmResult {
  final MatchModel match;
  final bool bothConfirmed;
  final bool justActivated;

  const MatchConfirmResult({
    required this.match,
    required this.bothConfirmed,
    this.justActivated = false,
  });
}
