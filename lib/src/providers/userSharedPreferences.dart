import 'package:shared_preferences/shared_preferences.dart';

class UserSharedPreferences {
  static final UserSharedPreferences _instance =
      new UserSharedPreferences._internal();

  factory UserSharedPreferences() {
    return _instance;
  }

  UserSharedPreferences._internal();

  SharedPreferences _preferences;

  initPreferences() async {
    this._preferences = await SharedPreferences.getInstance();
  }
  
  get userEmail {
    return _preferences.getString("user_email");
  }

  set userEmail(String value) {
    _preferences.setString("user_email", value);
  }
}
