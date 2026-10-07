class CountryModel {
  final int id;
  final String iso;
  final String name;
  final String nicename;
  final String? iso3;
  final int phonecode;
  final int ordering;

  const CountryModel({
    required this.id,
    required this.iso,
    required this.name,
    required this.nicename,
    this.iso3,
    required this.phonecode,
    this.ordering = 0,
  });

  factory CountryModel.fromMap(Map<String, dynamic> map) {
    return CountryModel(
      id: int.tryParse('${map['id']}') ?? 0,
      iso: '${map['iso'] ?? ''}',
      name: '${map['name'] ?? ''}',
      nicename: '${map['nicename'] ?? map['name'] ?? ''}',
      iso3: map['iso3']?.toString(),
      phonecode: int.tryParse('${map['phonecode'] ?? 0}') ?? 0,
      ordering: int.tryParse('${map['ordering'] ?? 0}') ?? 0,
    );
  }

  @override
  bool operator ==(Object other) => other is CountryModel && other.id == id;

  @override
  int get hashCode => id.hashCode;

  String get displayName =>
      nicename.trim().isNotEmpty ? nicename.trim() : name.trim();
}
