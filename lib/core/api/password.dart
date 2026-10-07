import 'dart:convert';

import 'package:crypto/crypto.dart';

/// Matches passwords stored in `users.password` (SHA-1 hex).
String hashPassword(String raw) =>
    sha1.convert(utf8.encode(raw)).toString();
