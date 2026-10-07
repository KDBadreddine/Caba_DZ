import 'country_model.dart';
import 'user_model.dart';

class TripModel {
  final String id;
  final String travelerId;
  final UserModel traveler;
  final int originCountryId;
  final String originCity;
  final int destinationCountryId;
  final DateTime travelDate;
  final int availableKg;
  final int pricePerKg;
  final String currency;
  final String? notes;
  final String status;
  final String? originCountryName;
  final String? destinationCountryName;
  final String? originIso;
  final String? destinationIso;

  const TripModel({
    required this.id,
    required this.travelerId,
    required this.traveler,
    required this.originCountryId,
    required this.originCity,
    required this.destinationCountryId,
    required this.travelDate,
    required this.availableKg,
    required this.pricePerKg,
    this.currency = 'EUR',
    this.notes,
    this.status = 'active',
    this.originCountryName,
    this.destinationCountryName,
    this.originIso,
    this.destinationIso,
  });

  String get fromCity =>
      (originCountryName != null && originCountryName!.isNotEmpty)
          ? originCountryName!
          : originCity;

  String get toCity => destinationCountryName ?? '';

  String get fromCode => originIso ?? '';

  String get toCode => destinationIso ?? '';

  double get availableWeight => availableKg.toDouble();

  String get departureTime => '';

  factory TripModel.fromMap(
    Map<String, dynamic> map, {
    UserModel? traveler,
    CountryModel? origin,
    CountryModel? destination,
  }) {
    return TripModel(
      id: '${map['id'] ?? ''}',
      travelerId: '${map['traveler_id'] ?? ''}',
      traveler: traveler ?? UserModel.fromMap(map),
      originCountryId: int.tryParse('${map['origin_country_id']}') ?? 0,
      originCity: '${map['origin_city'] ?? ''}',
      destinationCountryId:
          int.tryParse('${map['destination_country_id']}') ?? 0,
      travelDate: DateTime.tryParse('${map['travel_date'] ?? ''}') ??
          DateTime.now(),
      availableKg: int.tryParse('${map['available_kg'] ?? 1}') ?? 1,
      pricePerKg: int.tryParse('${map['price_per_kg'] ?? 1}') ?? 1,
      currency: '${map['currency'] ?? 'EUR'}',
      notes: map['notes']?.toString(),
      status: '${map['status'] ?? 'active'}',
      originCountryName: origin?.displayName,
      destinationCountryName: destination?.displayName,
      originIso: origin?.iso,
      destinationIso: destination?.iso,
    );
  }
}
