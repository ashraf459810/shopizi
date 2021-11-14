import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class ProfileProvider with ChangeNotifier {
  String get name => FirebaseAuth.instance.currentUser.displayName;

  String get phoneNumber => FirebaseAuth.instance.currentUser.phoneNumber;

  notify() => notifyListeners();
}
