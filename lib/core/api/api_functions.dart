import 'dart:convert';

import 'package:uuid/uuid.dart';

import '../../config/config.dart';
import '../../models/conversation_model.dart';
import '../../models/country_model.dart';
import '../../models/match_model.dart';
import '../../models/message_model.dart';
import '../../models/notification_model.dart';
import '../../models/slider_model.dart';
import '../../models/shipment_model.dart';
import '../../models/transaction_model.dart';
import '../../models/trip_model.dart';
import '../../models/user_model.dart';
import '../utils/country_flag.dart';
import '../utils/date_format.dart';
import 'api_parser.dart';
import 'api_service.dart';
import 'password.dart';
import 'session.dart';
import 'shared_data.dart';

class DbTables {
  static const users = 'users';
  static const trips = 'trips';
  static const requests = 'requests';
  static const matches = 'matches';
  static const notifications = 'notifications';
  static const transactions = 'transactions';
  static const reviews = 'reviews';
  static const country = 'country';
  static const slider = 'slider';
  static const prohibitedItems = 'prohibited_items';
  static const conversations = 'conversations';
  static const messages = 'messages';
}

const _uuid = Uuid();

Map<String, dynamic> selectPayload(
  String table, {
  Map<String, dynamic>? conditions,
  List<Map<String, dynamic>>? joins,
  Map<String, dynamic>? search,
  int? limit,
  int? offset,
  String? orderBy,
  bool softDelete = false,
}) {
  return {
    'action': 'select',
    'table': table,
    'options': {
      if (joins != null) 'joins': joins,
      if (search != null) 'search': search,
      if (limit != null) 'limit': limit,
      if (offset != null) 'offset': offset,
      if (orderBy != null) 'orderBy': orderBy,
      'conditions': {
        if (softDelete) 'deleted': 0,
        ...?conditions,
      },
    },
  };
}

Map<String, dynamic> insertPayload(
  String table,
  Map<String, dynamic> data, {
  List<Map<String, dynamic>>? tables,
}) {
  return {
    'action': 'insert',
    'table': table,
    'data': data,
    if (tables != null) 'tables': tables,
  };
}

Map<String, dynamic> updatePayload(
  String table,
  Map<String, dynamic> conditions,
  Map<String, dynamic> data,
) {
  return {
    'action': 'update',
    'table': table,
    'conditions': conditions,
    'data': data,
  };
}

Future<String> apiSelect(
  String table, {
  Map<String, dynamic>? conditions,
  List<Map<String, dynamic>>? joins,
  Map<String, dynamic>? search,
  int? limit,
  int? offset,
  String? orderBy,
  bool softDelete = false,
  bool showLog = true,
}) {
  return apiRequest(
    endpoint,
    selectPayload(
      table,
      conditions: conditions,
      joins: joins,
      search: search,
      limit: limit,
      offset: offset,
      orderBy: orderBy,
      softDelete: softDelete,
    ),
    showLog: showLog,
  );
}

Future<String> apiInsert(
  String table,
  Map<String, dynamic> data, {
  List<Map<String, dynamic>>? tables,
}) {
  return apiRequest(endpoint, insertPayload(table, data, tables: tables));
}

Future<String> apiUpdate(
  String table,
  Map<String, dynamic> conditions,
  Map<String, dynamic> data,
) {
  return apiRequest(endpoint, updatePayload(table, conditions, data));
}

bool apiResultOk(String result) {
  try {
    final decoded = json.decode(result);
    if (decoded is Map && decoded['success'] == true) return true;
    if (decoded is Map && decoded['data'] != null) return true;
  } catch (_) {}
  return result.contains('success') || result.contains('"id"');
}

// ─── users ───────────────────────────────────────────────────────────────────

Future<bool> login(String email, String password) async {
  final result = await apiSelect(
    DbTables.users,
    conditions: {
      'email': email.trim(),
      'password': hashPassword(password),
      'deleted': 0,
    },
    softDelete: false,
    limit: 1,
  );
  final users = parseApiList(result, UserModel.fromMap);
  if (users.isEmpty) return false;
  final user = users.first;
  if (user.status != 'active') return false;
  userInfo = user;
  await saveSession(user.id);
  return true;
}

Future<bool> restoreSession() async {
  final id = await readSavedUserId();
  if (id == null || id.isEmpty) return false;
  final user = await getUserById(id);
  if (user == null) return false;
  userInfo = user;
  return true;
}

Future<bool> registerUser({
  required String fullName,
  required String email,
  required String phone,
  required String password,
  String? country,
  String? city,
  String? avatarUrl,
}) async {
  final result = await apiInsert(DbTables.users, {
    'type': 'client',
    'full_name': fullName.trim(),
    'phone': phone.trim(),
    'email': email.trim(),
    'password': hashPassword(password),
    'role': 'both',
    'status': 'active',
    if (country != null) 'country': country,
    if (city != null) 'city': city,
    if (avatarUrl != null && avatarUrl.isNotEmpty) 'avatar_url': avatarUrl,
  });
  if (!apiResultOk(result)) return false;
  return login(email, password);
}

Future<UserModel?> getUserById(String id) async {
  final result = await apiSelect(
    DbTables.users,
    conditions: {'id': id, 'deleted': 0},
    limit: 1,
  );
  final users = parseApiList(result, UserModel.fromMap);
  return users.isEmpty ? null : users.first;
}

Future<Map<String, UserModel>> getUsersByIds(Iterable<String> ids) async {
  final unique = ids.where((e) => e.isNotEmpty).toSet().toList();
  if (unique.isEmpty) return {};
  final result = await apiSelect(
    DbTables.users,
    conditions: {
      'id': unique.length == 1 ? unique.first : unique,
      'deleted': 0,
    },
    limit: 200,
  );
  final users = parseApiList(result, UserModel.fromMap);
  return {for (final u in users) u.id: u};
}

// ─── country ─────────────────────────────────────────────────────────────────

Future<List<CountryModel>> getCountries() async {
  if (countryCache.isNotEmpty) return countryCache;

  var result = await apiSelect(
    DbTables.country,
    limit: 300,
    orderBy: 'ordering ASC',
    showLog: false,
  );
  var list = parseApiList(result, CountryModel.fromMap);
  if (list.isEmpty) {
    result = await apiSelect(
      DbTables.country,
      limit: 300,
      orderBy: 'nicename ASC',
      showLog: false,
    );
    list = parseApiList(result, CountryModel.fromMap);
  }
  list.sort((a, b) {
    final byOrder = a.ordering.compareTo(b.ordering);
    if (byOrder != 0) return byOrder;
    return a.nicename.toLowerCase().compareTo(b.nicename.toLowerCase());
  });
  countryCache = list;
  return countryCache;
}

// ─── sliders ─────────────────────────────────────────────────────────────────

Future<List<SliderModel>> getSliders({int limit = 20}) async {
  final result = await apiSelect(
    DbTables.slider,
    conditions: {'status': 'active'},
    limit: limit,
    orderBy: 'ordering ASC',
    softDelete: true,
  );
  final list = parseApiList(result, SliderModel.fromMap)
      .where((s) => s.resolvedImageUrl.isNotEmpty)
      .toList();
  list.sort((a, b) => a.ordering.compareTo(b.ordering));
  return list;
}

// ─── trips ───────────────────────────────────────────────────────────────────

Future<List<TripModel>> _hydrateTrips(List<Map<String, dynamic>> rows) async {
  await getCountries();
  final users = await getUsersByIds(rows.map((r) => '${r['traveler_id'] ?? ''}'));
  return rows.map((row) {
    final originId = int.tryParse('${row['origin_country_id']}') ?? 0;
    final destId = int.tryParse('${row['destination_country_id']}') ?? 0;
    final travelerId = '${row['traveler_id'] ?? ''}';
    return TripModel.fromMap(
      row,
      traveler: users[travelerId],
      origin: countryById(originId),
      destination: countryById(destId),
    );
  }).toList();
}

Future<List<TripModel>> getTrips({
  String? status,
  int? destinationCountryId,
  String? travelerId,
  int limit = 50,
}) async {
  final result = await apiSelect(
    DbTables.trips,
    conditions: {
      'deleted': 0,
      if (status != null) 'status': status,
      if (destinationCountryId != null)
        'destination_country_id': destinationCountryId,
      if (travelerId != null && travelerId.isNotEmpty) 'traveler_id': travelerId,
    },
    limit: limit,
    orderBy: 'id DESC',
  );
  return _hydrateTrips(parseApiList(result, (row) => row));
}

Future<List<TripModel>> getMyTrips() async {
  if (userInfo == null) return [];
  final result = await apiSelect(
    DbTables.trips,
    conditions: {'traveler_id': userInfo!.id, 'deleted': 0},
    limit: 100,
    orderBy: 'id DESC',
  );
  return _hydrateTrips(parseApiList(result, (row) => row));
}

Future<TripModel?> getTripById(String id) async {
  final result = await apiSelect(
    DbTables.trips,
    conditions: {'id': id, 'deleted': 0},
    limit: 1,
  );
  final list = await _hydrateTrips(parseApiList(result, (row) => row));
  return list.isEmpty ? null : list.first;
}

Future<bool> createTrip({
  required int originCountryId,
  required int destinationCountryId,
  required DateTime travelDate,
  required int availableKg,
  required int pricePerKg,
  String currency = 'EUR',
  String? notes,
}) async {
  if (userInfo == null) return false;
  await getCountries();
  final originName = countryById(originCountryId)?.displayName ?? '';
  final result = await apiInsert(DbTables.trips, {
    'traveler_id': userInfo!.id,
    'origin_country_id': originCountryId,
    'origin_city': originName,
    'destination_country_id': destinationCountryId,
    'travel_date':
        '${travelDate.year}-${travelDate.month.toString().padLeft(2, '0')}-${travelDate.day.toString().padLeft(2, '0')}',
    'available_kg': availableKg,
    'price_per_kg': pricePerKg,
    'currency': currency,
    if (notes != null && notes.isNotEmpty) 'notes': notes,
    'status': 'active',
    'created_by': int.tryParse(userInfo!.id),
    'deleted': 0,
  });
  return apiResultOk(result);
}

Future<bool> updateTrip({
  required String id,
  required int originCountryId,
  required int destinationCountryId,
  required DateTime travelDate,
  required int availableKg,
  required int pricePerKg,
  String currency = 'EUR',
  String? notes,
}) async {
  if (userInfo == null || id.isEmpty) return false;
  final existing = await getTripById(id);
  if (existing == null ||
      existing.travelerId != userInfo!.id ||
      existing.status != 'active') {
    return false;
  }
  await getCountries();
  final originName = countryById(originCountryId)?.displayName ?? '';
  final result = await apiUpdate(
    DbTables.trips,
    {'id': id},
    {
      'origin_country_id': originCountryId,
      'origin_city': originName,
      'destination_country_id': destinationCountryId,
      'travel_date':
          '${travelDate.year}-${travelDate.month.toString().padLeft(2, '0')}-${travelDate.day.toString().padLeft(2, '0')}',
      'available_kg': availableKg,
      'price_per_kg': pricePerKg,
      'currency': currency,
      'notes': notes ?? '',
      'modified_by': int.tryParse(userInfo!.id),
    },
  );
  return apiResultOk(result);
}

// ─── requests (shipments) ────────────────────────────────────────────────────

Future<List<ShipmentModel>> _hydrateRequests(
  List<Map<String, dynamic>> rows,
) async {
  await getCountries();
  final users = await getUsersByIds(rows.map((r) => '${r['sender_id'] ?? ''}'));
  return rows.map((row) {
    final senderId = '${row['sender_id'] ?? ''}';
    return ShipmentModel.fromMap({
      ...row,
      'origin_city': _asCountryName('${row['origin_city'] ?? ''}'),
      'destination_city': _asCountryName('${row['destination_city'] ?? ''}'),
    }, sender: users[senderId]);
  }).toList();
}

String _asCountryName(String raw) {
  final c = countryFromPlace(raw);
  if (c != null) return c.displayName;
  return raw;
}

Future<List<ShipmentModel>> getRequests({
  String? status,
  String? destinationCity,
  String? senderId,
  int limit = 50,
}) async {
  final result = await apiSelect(
    DbTables.requests,
    conditions: {
      if (status != null) 'status': status,
      if (destinationCity != null) 'destination_city': destinationCity,
      if (senderId != null && senderId.isNotEmpty) 'sender_id': senderId,
    },
    limit: limit,
    orderBy: 'created_at DESC',
  );
  return _hydrateRequests(parseApiList(result, (row) => row));
}

Future<List<ShipmentModel>> getMyRequests() async {
  if (userInfo == null) return [];
  final result = await apiSelect(
    DbTables.requests,
    conditions: {'sender_id': userInfo!.id},
    limit: 100,
    orderBy: 'created_at DESC',
  );
  return _hydrateRequests(parseApiList(result, (row) => row));
}

Future<ShipmentModel?> getRequestById(String id) async {
  if (id.isEmpty) return null;
  final result = await apiSelect(
    DbTables.requests,
    conditions: {'id': id},
    limit: 1,
  );
  final list = await _hydrateRequests(parseApiList(result, (row) => row));
  return list.isEmpty ? null : list.first;
}

Future<MatchModel?> getMatchByRequestId(String requestId) async {
  if (requestId.isEmpty) return null;
  final result = await apiSelect(
    DbTables.matches,
    conditions: {'request_id': requestId},
    limit: 5,
    orderBy: 'created_at DESC',
  );
  final list = parseApiList(result, MatchModel.fromMap);
  if (list.isEmpty) return null;
  final active = list.where((m) => m.status != 'cancelled');
  return active.isNotEmpty ? active.first : list.first;
}

Future<bool> createRequest({
  required String itemDescription,
  required String itemCategory,
  required double weightKg,
  required String originCountry,
  required String destinationCountry,
  double? maxBudget,
  String? photoUrl,
}) async {
  if (userInfo == null) return false;
  final result = await apiInsert(DbTables.requests, {
    'id': _uuid.v4(),
    'sender_id': userInfo!.id,
    'item_description': itemDescription,
    'item_category': itemCategory,
    'weight_kg': weightKg,
    'origin_city': originCountry,
    'destination_city': destinationCountry,
    if (maxBudget != null) 'max_budget': maxBudget,
    if (photoUrl != null) 'photo_url': photoUrl,
    'status': 'open',
  });
  return apiResultOk(result);
}

Future<bool> updateRequest({
  required String id,
  required String itemDescription,
  required String itemCategory,
  required double weightKg,
  required String originCountry,
  required String destinationCountry,
  double? maxBudget,
  String? photoUrl,
}) async {
  if (userInfo == null || id.isEmpty) return false;
  final existing = await getRequestById(id);
  if (existing == null ||
      existing.senderId != userInfo!.id ||
      existing.status != 'open') {
    return false;
  }
  final result = await apiUpdate(
    DbTables.requests,
    {'id': id},
    {
      'item_description': itemDescription,
      'item_category': itemCategory,
      'weight_kg': weightKg,
      'origin_city': originCountry,
      'destination_city': destinationCountry,
      if (maxBudget != null) 'max_budget': maxBudget,
      if (photoUrl != null) 'photo_url': photoUrl,
    },
  );
  return apiResultOk(result);
}

// ─── matches ─────────────────────────────────────────────────────────────────

Future<List<MatchModel>> getMatches({String? status}) async {
  final result = await apiSelect(
    DbTables.matches,
    conditions: {
      if (status != null) 'status': status,
    },
    limit: 100,
    orderBy: 'created_at DESC',
  );
  return parseApiList(result, MatchModel.fromMap);
}

Future<bool> createMatch({
  required String tripId,
  required String requestId,
  required double agreedPrice,
  String currency = 'EUR',
}) async {
  final result = await apiInsert(DbTables.matches, {
    'id': _uuid.v4(),
    'trip_id': tripId,
    'request_id': requestId,
    'agreed_price': agreedPrice,
    'currency': currency,
    'status': 'pending',
  });
  return apiResultOk(result);
}

Future<MatchModel?> getMatchById(String id) async {
  if (id.isEmpty) return null;
  final result = await apiSelect(
    DbTables.matches,
    conditions: {'id': id},
    limit: 1,
  );
  final list = parseApiList(result, MatchModel.fromMap);
  return list.isEmpty ? null : list.first;
}

Future<MatchModel?> getMatchForConversation(String conversationId) async {
  if (conversationId.isEmpty) return null;
  final result = await apiSelect(
    DbTables.matches,
    conditions: {'conversation_id': conversationId},
    limit: 10,
    orderBy: 'created_at DESC',
  );
  final list = parseApiList(result, MatchModel.fromMap);
  if (list.isEmpty) return null;
  final active = list.where((m) => m.status != 'cancelled');
  return active.isNotEmpty ? active.first : list.first;
}

Future<MatchModel?> getMatchByQrToken(String token) async {
  if (token.isEmpty) return null;
  final result = await apiSelect(
    DbTables.matches,
    conditions: {'qr_token': token},
    limit: 1,
  );
  final list = parseApiList(result, MatchModel.fromMap);
  return list.isEmpty ? null : list.first;
}

class _MatchListings {
  final String? tripId;
  final String? requestId;
  final double agreedPrice;
  final String currency;

  const _MatchListings({
    this.tripId,
    this.requestId,
    required this.agreedPrice,
    required this.currency,
  });
}

Future<_MatchListings> _listingsForMatch({
  required String travelerId,
  required String senderId,
}) async {
  final trips = await getTrips(
    travelerId: travelerId,
    status: 'active',
    limit: 20,
  );
  final reqs = await getRequests(
    senderId: senderId,
    status: 'open',
    limit: 20,
  );
  final trip = trips.isEmpty ? null : trips.first;
  final req = reqs.isEmpty ? null : reqs.first;
  final price = req?.maxBudget ??
      (trip != null
          ? trip.pricePerKg.toDouble() * (req?.weight ?? 1)
          : 0);
  return _MatchListings(
    tripId: trip?.id,
    requestId: req?.id,
    agreedPrice: price,
    currency: trip?.currency ?? 'EUR',
  );
}

/// Returns `traveler` or `sender` when listings/roles make it obvious.
Future<String?> inferMyMatchRole(String otherUserId) async {
  final me = userInfo;
  if (me == null || otherUserId.isEmpty) return null;

  final myTrips = await getTrips(travelerId: me.id, status: 'active', limit: 20);
  final otherTrips =
      await getTrips(travelerId: otherUserId, status: 'active', limit: 20);
  final myReqs = await getRequests(senderId: me.id, status: 'open', limit: 20);
  final otherReqs =
      await getRequests(senderId: otherUserId, status: 'open', limit: 20);

  final iFly = myTrips.isNotEmpty;
  final theyFly = otherTrips.isNotEmpty;
  final iSend = myReqs.isNotEmpty;
  final theySend = otherReqs.isNotEmpty;

  if (iFly && theySend && !theyFly) return 'traveler';
  if (theyFly && iSend && !iFly) return 'sender';
  if (iFly && !theyFly && !iSend) return 'traveler';
  if (theyFly && !iFly && !theySend) return 'sender';
  if (iSend && !theySend && !iFly) return 'sender';
  if (theySend && !iSend && !theyFly) return 'traveler';

  if (me.role == 'traveler' && theySend) return 'traveler';
  if (me.role == 'sender' && theyFly) return 'sender';
  if (me.role == 'traveler' && !iSend) return 'traveler';
  if (me.role == 'sender' && !iFly) return 'sender';
  return null;
}

Future<void> createAppNotification({
  required String userId,
  required String title,
  required String body,
  String? relatedMatchId,
}) async {
  if (userId.isEmpty) return;
  await apiInsert(DbTables.notifications, {
    'id': _uuid.v4(),
    'user_id': userId,
    'title': title,
    'body': body,
    if (relatedMatchId != null && relatedMatchId.isNotEmpty)
      'related_match_id': relatedMatchId,
    'is_read': 0,
  });
}

String _deliveryCode() =>
    _uuid.v4().replaceAll('-', '').substring(0, 6).toUpperCase();

Future<MatchModel?> _activateConfirmedMatch(
  MatchModel match,
  ConversationModel conversation,
) async {
  final token = match.hasQr ? match.qrToken! : _uuid.v4();
  final code = (match.deliveryCode != null && match.deliveryCode!.isNotEmpty)
      ? match.deliveryCode!
      : _deliveryCode();
  final result = await apiUpdate(
    DbTables.matches,
    {'id': match.id},
    {
      'status': 'confirmed',
      'qr_token': token,
      'delivery_code': code,
      'traveler_confirmed': 1,
      'sender_confirmed': 1,
    },
  );
  if (!apiResultOk(result)) return null;

  await apiUpdate(
    DbTables.conversations,
    {'id': conversation.id},
    {'match_id': match.id},
  );
  if (match.tripId.isNotEmpty) {
    await apiUpdate(
      DbTables.trips,
      {'id': match.tripId},
      {'status': 'matched'},
    );
  }
  if (match.requestId.isNotEmpty) {
    await apiUpdate(
      DbTables.requests,
      {'id': match.requestId},
      {'status': 'matched'},
    );
  }
  return getMatchById(match.id);
}

/// Both users must call this. QR is generated only after both confirm.
Future<MatchConfirmResult?> confirmConversationMatch({
  required String otherUserId,
  required String myRole,
}) async {
  final me = userInfo;
  if (me == null) return null;
  if (myRole != 'traveler' && myRole != 'sender') return null;
  if (otherUserId.isEmpty || otherUserId == me.id) return null;

  var conversation = await findConversationWith(otherUserId);
  conversation ??= await getOrCreateConversation(otherUserId: otherUserId);
  if (conversation == null) return null;

  final travelerId = myRole == 'traveler' ? me.id : otherUserId;
  final senderId = myRole == 'sender' ? me.id : otherUserId;
  final travelerInt = int.tryParse(travelerId);
  final senderInt = int.tryParse(senderId);
  if (travelerInt == null || senderInt == null) return null;

  var match = await getMatchForConversation(conversation.id);
  if (match == null &&
      conversation.matchId != null &&
      conversation.matchId!.isNotEmpty) {
    match = await getMatchById(conversation.matchId!);
  }

  if (match == null) {
    final listings = await _listingsForMatch(
      travelerId: travelerId,
      senderId: senderId,
    );
    final id = _uuid.v4();
    final data = <String, dynamic>{
      'id': id,
      if (listings.tripId != null && listings.tripId!.isNotEmpty)
        'trip_id': listings.tripId,
      if (listings.requestId != null && listings.requestId!.isNotEmpty)
        'request_id': listings.requestId,
      'conversation_id': conversation.id,
      'traveler_id': travelerInt,
      'sender_id': senderInt,
      'traveler_confirmed': myRole == 'traveler' ? 1 : 0,
      'sender_confirmed': myRole == 'sender' ? 1 : 0,
      'agreed_price': listings.agreedPrice,
      'currency': listings.currency,
      'status': 'pending',
    };
    var inserted = apiResultOk(await apiInsert(DbTables.matches, data));
    if (!inserted &&
        (data.containsKey('trip_id') || data.containsKey('request_id'))) {
      data.remove('trip_id');
      data.remove('request_id');
      inserted = apiResultOk(await apiInsert(DbTables.matches, data));
    }
    match = inserted
        ? await getMatchById(id)
        : await getMatchForConversation(conversation.id);
  }

  if (match == null) return null;
  if (match.isDelivered) {
    return MatchConfirmResult(match: match, bothConfirmed: true);
  }
  if (match.isCancelled) {
    await apiUpdate(
      DbTables.matches,
      {'id': match.id},
      {
        'status': 'pending',
        'conversation_id': conversation.id,
        'traveler_id': travelerInt,
        'sender_id': senderInt,
        'traveler_confirmed': myRole == 'traveler' ? 1 : 0,
        'sender_confirmed': myRole == 'sender' ? 1 : 0,
      },
    );
    match = await getMatchById(match.id);
    if (match == null) return null;
    return MatchConfirmResult(
      match: match,
      bothConfirmed: match.bothConfirmed,
    );
  }

  final iAmTraveler = match.travelerId.isEmpty
      ? myRole == 'traveler'
      : match.iAmTraveler(me.id);
  final iAmSender =
      match.senderId.isEmpty ? myRole == 'sender' : match.iAmSender(me.id);
  if (!iAmTraveler && !iAmSender) return null;

  final alreadyBoth = match.bothConfirmed && match.isConfirmed;
  if (!alreadyBoth) {
    await apiUpdate(
      DbTables.matches,
      {'id': match.id},
      {
        if (iAmTraveler) 'traveler_confirmed': 1,
        if (iAmSender) 'sender_confirmed': 1,
        if (match.travelerId.isEmpty) 'traveler_id': travelerInt,
        if (match.senderId.isEmpty) 'sender_id': senderInt,
        if (match.conversationId.isEmpty) 'conversation_id': conversation.id,
      },
    );
    match = await getMatchById(match.id) ?? match;
  }

  var justActivated = false;
  if (match.bothConfirmed && !match.isConfirmed && !match.isDelivered) {
    final activated = await _activateConfirmedMatch(match, conversation);
    if (activated != null) {
      match = activated;
      justActivated = true;
    }
  }

  final otherId = match.iAmTraveler(me.id) ? match.senderId : match.travelerId;
  await createAppNotification(
    userId: otherId,
    title: justActivated ? 'تمت المطابقة' : 'تأكيد مطابقة',
    body: justActivated
        ? 'تم الاتفاق. يمكن للمرسل عرض رمز QR والتسليم يتم بمسحه.'
        : '${me.fullName} أكّد المطابقة',
    relatedMatchId: match.id,
  );

  return MatchConfirmResult(
    match: match,
    bothConfirmed: match.bothConfirmed && (match.isConfirmed || match.hasQr),
    justActivated: justActivated,
  );
}

enum DeliveryScanResult {
  success,
  alreadyDone,
  invalid,
  notTraveler,
  notReady,
}

Future<DeliveryScanResult> completeDeliveryByQr(
  String raw, {
  String? expectedMatchId,
}) async {
  final me = userInfo;
  if (me == null) return DeliveryScanResult.invalid;

  final parsed = MatchModel.parseQrPayload(raw);
  if (parsed == null) return DeliveryScanResult.invalid;
  if (expectedMatchId != null &&
      expectedMatchId.isNotEmpty &&
      parsed.matchId != expectedMatchId) {
    return DeliveryScanResult.invalid;
  }

  final match = await getMatchById(parsed.matchId);
  if (match == null) return DeliveryScanResult.invalid;
  if (match.qrToken != parsed.token) return DeliveryScanResult.invalid;
  if (!match.iAmTraveler(me.id)) return DeliveryScanResult.notTraveler;
  if (match.isDelivered) return DeliveryScanResult.alreadyDone;
  if (!match.isConfirmed && match.status != 'handed_over') {
    return DeliveryScanResult.notReady;
  }

  final updated = await apiUpdate(
    DbTables.matches,
    {'id': match.id},
    {'status': 'delivered'},
  );
  if (!apiResultOk(updated)) return DeliveryScanResult.invalid;

  if (match.requestId.isNotEmpty) {
    await apiUpdate(
      DbTables.requests,
      {'id': match.requestId},
      {'status': 'completed'},
    );
  }
  if (match.tripId.isNotEmpty) {
    await apiUpdate(
      DbTables.trips,
      {'id': match.tripId},
      {'status': 'completed'},
    );
  }

  ConversationModel? conversation;
  if (match.conversationId.isNotEmpty) {
    conversation = await getConversationById(match.conversationId);
  }
  if (conversation != null) {
    await sendMessage(
      conversation: conversation,
      body: 'تم تسليم الشحنة ✓',
    );
  }
  await createAppNotification(
    userId: match.senderId,
    title: 'تم التسليم',
    body: 'تم تأكيد تسليم الشحنة عبر رمز QR',
    relatedMatchId: match.id,
  );
  return DeliveryScanResult.success;
}

// ─── notifications ───────────────────────────────────────────────────────────

Future<List<AppNotification>> getNotifications() async {
  if (userInfo == null) return [];
  final result = await apiSelect(
    DbTables.notifications,
    conditions: {'user_id': userInfo!.id},
    limit: 50,
    orderBy: 'created_at DESC',
  );
  return parseApiList(result, AppNotification.fromMap);
}

Future<bool> markNotificationRead(String id) async {
  final result = await apiUpdate(
    DbTables.notifications,
    {'id': id},
    {'is_read': 1},
  );
  return apiResultOk(result);
}

// ─── transactions ────────────────────────────────────────────────────────────

Future<List<TransactionModel>> getTransactions({
  String? matchId,
  EscrowStatus? status,
  int limit = 100,
}) async {
  final result = await apiSelect(
    DbTables.transactions,
    conditions: {
      if (matchId != null) 'match_id': matchId,
      if (status != null) 'escrow_status': status.name,
    },
    limit: limit,
    orderBy: 'id DESC',
  );
  return parseApiList(result, TransactionModel.fromMap);
}

Future<int?> createTransaction({
  required String matchId,
  required double amount,
  double commission = 0,
  String currency = 'EUR',
  String paymentProvider = 'stripe',
  String? providerRef,
}) async {
  final result = await apiInsert(DbTables.transactions, {
    'match_id': matchId,
    'amount': amount,
    'commission': commission,
    'currency': currency,
    'payment_provider': paymentProvider,
    if (providerRef != null) 'provider_ref': providerRef,
    'escrow_status': EscrowStatus.held.name,
  });
  try {
    return extractInsertedId(json.decode(result), DbTables.transactions);
  } catch (_) {
    return null;
  }
}

Future<bool> updateEscrowStatus({
  required int id,
  required EscrowStatus status,
  DateTime? releasedAt,
}) async {
  final result = await apiUpdate(
    DbTables.transactions,
    {'id': id},
    {
      'escrow_status': status.name,
      if (status == EscrowStatus.released)
        'released_at': (releasedAt ?? DateTime.now()).toIso8601String(),
    },
  );
  return apiResultOk(result);
}

// ─── chat ────────────────────────────────────────────────────────────────────

int? _asUserInt(String id) => int.tryParse(id);

(int, int) _orderedUserIds(String a, String b) {
  final ia = int.tryParse(a) ?? 0;
  final ib = int.tryParse(b) ?? 0;
  return ia <= ib ? (ia, ib) : (ib, ia);
}

Future<List<ConversationModel>> _hydrateConversations(
  List<Map<String, dynamic>> rows,
) async {
  if (userInfo == null || rows.isEmpty) return [];
  final myId = userInfo!.id;
  final otherIds = rows.map((row) {
    final one = '${row['user_one_id'] ?? ''}';
    final two = '${row['user_two_id'] ?? ''}';
    return one == myId ? two : one;
  });
  final users = await getUsersByIds(otherIds);
  return rows.map((row) {
    final one = '${row['user_one_id'] ?? ''}';
    final two = '${row['user_two_id'] ?? ''}';
    final otherId = one == myId ? two : one;
    return ConversationModel.fromMap(
      row,
      myId: myId,
      otherUser: users[otherId],
    );
  }).toList();
}

Future<List<ConversationModel>> getMyConversations() async {
  if (userInfo == null) return [];
  final myId = _asUserInt(userInfo!.id);
  if (myId == null) return [];

  final asOne = await apiSelect(
    DbTables.conversations,
    conditions: {'user_one_id': myId, 'deleted': 0},
    limit: 100,
    orderBy: 'last_message_at DESC',
  );
  final asTwo = await apiSelect(
    DbTables.conversations,
    conditions: {'user_two_id': myId, 'deleted': 0},
    limit: 100,
    orderBy: 'last_message_at DESC',
  );

  final seen = <String>{};
  final rows = <Map<String, dynamic>>[
    ...parseApiList(asOne, (row) => row),
    ...parseApiList(asTwo, (row) => row),
  ].where((row) => seen.add('${row['id']}')).toList();

  final list = await _hydrateConversations(rows);
  list.sort((a, b) {
    final at = a.lastMessageAt ?? DateTime.fromMillisecondsSinceEpoch(0);
    final bt = b.lastMessageAt ?? DateTime.fromMillisecondsSinceEpoch(0);
    return bt.compareTo(at);
  });
  return list;
}

Future<ConversationModel?> getConversationById(String id) async {
  if (userInfo == null || id.isEmpty) return null;
  final result = await apiSelect(
    DbTables.conversations,
    conditions: {'id': id, 'deleted': 0},
    limit: 1,
  );
  final list = await _hydrateConversations(parseApiList(result, (row) => row));
  return list.isEmpty ? null : list.first;
}

Future<ConversationModel?> findConversationWith(String otherUserId) async {
  if (userInfo == null) return null;
  final (one, two) = _orderedUserIds(userInfo!.id, otherUserId);
  if (one == 0 || two == 0 || one == two) return null;
  final result = await apiSelect(
    DbTables.conversations,
    conditions: {'user_one_id': one, 'user_two_id': two, 'deleted': 0},
    limit: 1,
  );
  final list = await _hydrateConversations(parseApiList(result, (row) => row));
  return list.isEmpty ? null : list.first;
}

Future<ConversationModel?> getOrCreateConversation({
  required String otherUserId,
  String? matchId,
}) async {
  if (userInfo == null) return null;
  if (otherUserId.isEmpty || otherUserId == userInfo!.id) return null;

  final existing = await findConversationWith(otherUserId);
  if (existing != null) return existing;

  final (one, two) = _orderedUserIds(userInfo!.id, otherUserId);
  if (one == 0 || two == 0) return null;
  final id = _uuid.v4();
  final result = await apiInsert(DbTables.conversations, {
    'id': id,
    'user_one_id': one,
    'user_two_id': two,
    if (matchId != null && matchId.isNotEmpty) 'match_id': matchId,
    'deleted': 0,
  });
  if (!apiResultOk(result)) {
    return findConversationWith(otherUserId);
  }
  return await getConversationById(id) ??
      await findConversationWith(otherUserId);
}

Future<List<MessageModel>> getMessages(String conversationId) async {
  if (conversationId.isEmpty) return [];
  final result = await apiSelect(
    DbTables.messages,
    conditions: {'conversation_id': conversationId, 'deleted': 0},
    limit: 200,
    orderBy: 'created_at ASC',
  );
  return parseApiList(result, MessageModel.fromMap);
}

Future<MessageModel?> sendMessage({
  required ConversationModel conversation,
  required String body,
  String messageType = 'text',
  String? attachmentUrl,
}) async {
  if (userInfo == null) return null;
  final text = body.trim();
  if (text.isEmpty) return null;
  final senderId = _asUserInt(userInfo!.id);
  if (senderId == null) return null;

  final id = _uuid.v4();
  final now = DateTime.now();
  final result = await apiInsert(DbTables.messages, {
    'id': id,
    'conversation_id': conversation.id,
    'sender_id': senderId,
    'body': text,
    'message_type': messageType,
    if (attachmentUrl != null) 'attachment_url': attachmentUrl,
    'is_read': 0,
    'deleted': 0,
  });
  if (!apiResultOk(result)) return null;

  final preview = text.length > 500 ? text.substring(0, 500) : text;
  final iAmOne = conversation.isUserOne(userInfo!.id);
  await apiUpdate(
    DbTables.conversations,
    {'id': conversation.id},
    {
      'last_message': preview,
      'last_message_at': formatSqlDateTime(now),
      'last_sender_id': senderId,
      if (iAmOne)
        'user_two_unread': conversation.userTwoUnread + 1
      else
        'user_one_unread': conversation.userOneUnread + 1,
    },
  );

  return MessageModel(
    id: id,
    conversationId: conversation.id,
    senderId: userInfo!.id,
    body: text,
    attachmentUrl: attachmentUrl,
    messageType: messageType,
    createdAt: now,
  );
}

Future<void> markConversationRead(ConversationModel conversation) async {
  if (userInfo == null) return;
  final iAmOne = conversation.isUserOne(userInfo!.id);
  await apiUpdate(
    DbTables.conversations,
    {'id': conversation.id},
    {if (iAmOne) 'user_one_unread': 0 else 'user_two_unread': 0},
  );
  final otherId = _asUserInt(conversation.otherUser.id);
  if (otherId == null) return;
  await apiUpdate(
    DbTables.messages,
    {
      'conversation_id': conversation.id,
      'sender_id': otherId,
      'is_read': 0,
    },
    {
      'is_read': 1,
      'read_at': formatSqlDateTime(DateTime.now()),
    },
  );
}

Future<void> touchLastSeen() async {
  if (userInfo == null) return;
  await apiUpdate(
    DbTables.users,
    {'id': userInfo!.id},
    {'last_seen_at': formatSqlDateTime(DateTime.now())},
  );
}

Future<bool> updateProfile({
  required String fullName,
  required String email,
  required String phone,
  String? country,
  String? city,
  String? role,
  String? avatarUrl,
}) async {
  if (userInfo == null) return false;
  final result = await apiUpdate(
    DbTables.users,
    {'id': userInfo!.id},
    {
      'full_name': fullName.trim(),
      'email': email.trim(),
      'phone': phone.trim(),
      if (country != null) 'country': country.trim(),
      if (city != null) 'city': city.trim(),
      if (role != null) 'role': role,
      if (avatarUrl != null) 'avatar_url': avatarUrl,
    },
  );
  if (!apiResultOk(result)) return false;
  final fresh = await getUserById(userInfo!.id);
  userInfo = fresh ??
      userInfo!.copyWith(
        fullName: fullName.trim(),
        email: email.trim(),
        phone: phone.trim(),
        country: country?.trim(),
        city: city?.trim(),
        role: role,
        avatarUrl: avatarUrl,
      );
  return true;
}
