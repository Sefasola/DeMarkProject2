import 'package:flutter/foundation.dart';

class LoginStatus extends ChangeNotifier {
  bool isLoggedIn = false;
  int userId = 0;
  String userName = "default";
  String level = "default";

  void toggleLogStatus() {
    isLoggedIn = !isLoggedIn;
    notifyListeners();
  }

  void updateUser(int newValue, String usercom, String levelnew) {
    userName = usercom;
    userId = newValue;
    level = levelnew;
    notifyListeners(); // This will notify any listeners that the value has changed
  }
}
