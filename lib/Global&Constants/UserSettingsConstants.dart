import 'package:skywa/services/userServices.dart';
UserSetting userSettings = UserSetting();
UserInfo userInfo;
class UserSetting {
  IntKey numUsages = IntKey(0, "numUsages");
  StringKey deviceID = StringKey(null, "deviceID");
  BoolKey userSetting1 = BoolKey(false, "userSetting1");
  BoolKey retiredRelease = BoolKey(false, "retiredRelease");
}

class BoolKey {
  bool value;
  String key;
  BoolKey(this.value, this.key);
}

class IntKey {
  int value;
  String key;
  IntKey(this.value, this.key);
}

class StringKey {
  String value;
  String key;
  StringKey(this.value, this.key);
}
