import 'user_model.dart';

/// Maps to the `requests` table.
class ShipmentModel {
  final String id;
  final String senderId;
  final UserModel sender;
  final String itemDescription;
  final String itemCategory;
  final double weight;
  final String? photoUrl;
  final String originCountry;
  final String destinationCountry;
  final double? maxBudget;
  final String status;

  const ShipmentModel({
    required this.id,
    required this.senderId,
    required this.sender,
    required this.itemDescription,
    required this.itemCategory,
    required this.weight,
    this.photoUrl,
    required this.originCountry,
    required this.destinationCountry,
    this.maxBudget,
    this.status = 'open',
  });

  String get fromCity => originCountry;
  String get toCity => destinationCountry;
  String get fromCode => '';
  String get toCode => '';
  String get packageType => itemCategory;
  String? get notes => itemDescription;
  double get length => 0;
  double get width => 0;
  double get height => 0;

  factory ShipmentModel.fromMap(
    Map<String, dynamic> map, {
    UserModel? sender,
  }) {
    return ShipmentModel(
      id: '${map['id'] ?? ''}',
      senderId: '${map['sender_id'] ?? ''}',
      sender: sender ?? UserModel.fromMap(map),
      itemDescription: '${map['item_description'] ?? ''}',
      itemCategory: '${map['item_category'] ?? ''}',
      weight: double.tryParse('${map['weight_kg'] ?? 0}') ?? 0,
      photoUrl: map['photo_url']?.toString(),
      originCountry: '${map['origin_city'] ?? ''}',
      destinationCountry: '${map['destination_city'] ?? ''}',
      maxBudget: double.tryParse('${map['max_budget'] ?? ''}'),
      status: '${map['status'] ?? 'open'}',
    );
  }
}
