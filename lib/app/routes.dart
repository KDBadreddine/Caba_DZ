import 'package:flutter/material.dart';
import '../features/auth/splash_screen.dart';
import '../features/auth/login_screen.dart';
import '../features/auth/register_screen.dart';
import '../features/home/home_screen.dart';
import '../features/trips/add_trip_screen.dart';
import '../features/trips/available_trips_screen.dart';
import '../features/trips/trip_detail_screen.dart';
import '../features/shipments/add_shipment_screen.dart';
import '../features/shipments/available_shipments_screen.dart';
import '../features/shipments/shipment_detail_screen.dart';
import '../features/chat/chat_screen.dart';
import '../features/chat/messages_screen.dart';
import '../features/orders/orders_screen.dart';
import '../features/notifications/notifications_screen.dart';
import '../features/search/search_screen.dart';
import '../features/account/account_screen.dart';
import '../features/account/edit_profile_screen.dart';
import '../features/account/settings_screen.dart';
import '../features/match/match_qr_screen.dart';
import '../features/match/scan_delivery_screen.dart';
import '../models/conversation_model.dart';
import '../models/match_model.dart';
import '../models/shipment_model.dart';
import '../models/trip_model.dart';

final RouteObserver<ModalRoute<void>> appRouteObserver =
    RouteObserver<ModalRoute<void>>();

class AppRoutes {
  AppRoutes._();

  static const String splash              = '/';
  static const String login               = '/login';
  static const String register            = '/register';
  static const String home                = '/home';
  static const String addTrip             = '/add-trip';
  static const String availableTrips      = '/available-trips';
  static const String tripDetail          = '/trip-detail';
  static const String addShipment         = '/add-shipment';
  static const String availableShipments  = '/available-shipments';
  static const String shipmentDetail      = '/shipment-detail';
  static const String messages            = '/messages';
  static const String chat                = '/chat';
  static const String orders              = '/orders';
  static const String notifications       = '/notifications';
  static const String search              = '/search';
  static const String account             = '/account';
  static const String editProfile         = '/edit-profile';
  static const String settings            = '/settings';
  static const String matchQr             = '/match-qr';
  static const String scanDelivery        = '/scan-delivery';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return _fade(const SplashScreen());
      case login:
        return _slide(const LoginScreen());
      case register:
        return _slide(const RegisterScreen());
      case home:
        return _fade(const HomeScreen());
      case addTrip:
        final editTrip = settings.arguments is TripModel
            ? settings.arguments as TripModel
            : null;
        return _slide(AddTripScreen(trip: editTrip));
      case availableTrips:
        return _slide(const AvailableTripsScreen());
      case tripDetail:
        final trip = settings.arguments as TripModel?;
        return _slide(TripDetailScreen(trip: trip));
      case addShipment:
        final editShip = settings.arguments is ShipmentModel
            ? settings.arguments as ShipmentModel
            : null;
        return _slide(AddShipmentScreen(shipment: editShip));
      case availableShipments:
        return _slide(const AvailableShipmentsScreen());
      case shipmentDetail:
        final shipment = settings.arguments as ShipmentModel?;
        return _slide(ShipmentDetailScreen(shipment: shipment));
      case messages:
        return _fade(const MessagesScreen());
      case chat:
        final args = settings.arguments as Map<String, dynamic>?;
        return _slide(ChatScreen(
          otherUserId: '${args?['otherUserId'] ?? ''}',
          userName: args?['userName'] ?? 'محادثة',
          userAvatar: args?['userAvatar'] as String?,
          conversation: args?['conversation'] as ConversationModel?,
        ));
      case orders:
        return _slide(const OrdersScreen());
      case notifications:
        return _slide(const NotificationsScreen());
      case search:
        return _slide(const SearchScreen());
      case account:
        return _slide(const AccountScreen());
      case editProfile:
        return _slide(const EditProfileScreen());
      case AppRoutes.settings:
        return _slide(const SettingsScreen());
      case matchQr:
        final qrArgs = settings.arguments as Map<String, dynamic>?;
        final qrMatch = qrArgs?['match'];
        if (qrMatch is! MatchModel) return _fade(const SplashScreen());
        return _slide(MatchQrScreen(
          match: qrMatch,
          otherName: '${qrArgs?['otherName'] ?? ''}',
        ));
      case scanDelivery:
        final scanMatch = settings.arguments;
        if (scanMatch is! MatchModel) return _fade(const SplashScreen());
        return _slide(ScanDeliveryScreen(match: scanMatch));
      default:
        return _fade(const SplashScreen());
    }
  }

  static PageRouteBuilder _fade(Widget page) => PageRouteBuilder(
    pageBuilder: (ctx, animation, secondary) => page,
    transitionsBuilder: (ctx, animation, secondary, child) =>
        FadeTransition(opacity: animation, child: child),
    transitionDuration: const Duration(milliseconds: 300),
  );

  static PageRouteBuilder _slide(Widget page) => PageRouteBuilder(
    pageBuilder: (ctx, animation, secondary) => page,
    transitionsBuilder: (ctx, animation, secondary, child) => SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0.05, 0),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
      child: FadeTransition(opacity: animation, child: child),
    ),
    transitionDuration: const Duration(milliseconds: 280),
  );
}
