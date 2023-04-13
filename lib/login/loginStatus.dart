import 'package:flutter/foundation.dart';

class LoginStatus extends ChangeNotifier {
  bool isLoggedIn = false;

  //bool get isLoggedIn => _isLoggedIn;

  /*set isLoggedIn(bool value) {
    _isLoggedIn = value;
    notifyListeners();
  }*/

  void toggleLogStatus() {
    isLoggedIn = !isLoggedIn;
    notifyListeners();
  }
}
