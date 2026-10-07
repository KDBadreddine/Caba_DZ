enum EscrowStatus { held, released, refunded }

EscrowStatus escrowStatusFrom(String? value) {
  switch (value) {
    case 'released':
      return EscrowStatus.released;
    case 'refunded':
      return EscrowStatus.refunded;
    default:
      return EscrowStatus.held;
  }
}

class TransactionModel {
  final int id;
  final String matchId;
  final double amount;
  final double commission;
  final String currency;
  final String paymentProvider;
  final String? providerRef;
  final EscrowStatus escrowStatus;
  final DateTime? releasedAt;
  final DateTime createdAt;

  const TransactionModel({
    required this.id,
    required this.matchId,
    required this.amount,
    required this.commission,
    required this.currency,
    required this.paymentProvider,
    this.providerRef,
    required this.escrowStatus,
    this.releasedAt,
    required this.createdAt,
  });

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: int.tryParse('${map['id']}') ?? 0,
      matchId: '${map['match_id'] ?? ''}',
      amount: double.tryParse('${map['amount']}') ?? 0,
      commission: double.tryParse('${map['commission']}') ?? 0,
      currency: '${map['currency'] ?? 'EUR'}',
      paymentProvider: '${map['payment_provider'] ?? 'stripe'}',
      providerRef: map['provider_ref']?.toString(),
      escrowStatus: escrowStatusFrom(map['escrow_status']?.toString()),
      releasedAt: DateTime.tryParse('${map['released_at'] ?? ''}'),
      createdAt:
          DateTime.tryParse('${map['created_at'] ?? ''}') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'match_id': matchId,
      'amount': amount,
      'commission': commission,
      'currency': currency,
      'payment_provider': paymentProvider,
      if (providerRef != null) 'provider_ref': providerRef,
      'escrow_status': escrowStatus.name,
      if (releasedAt != null) 'released_at': releasedAt!.toIso8601String(),
    };
  }
}
